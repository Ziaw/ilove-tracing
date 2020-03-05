require 'ilove/tracing/version'
require 'active_support/dependencies'

module ILove
  module Tracing
    class Configuration
      def self.config_param(symbol, default_value = nil, &block)
        raise 'wrong args' if !default_value.nil? && block_given?

        if block_given?
          class_variable_set("@@#{symbol}_default", block)
          class_eval(<<~RUBY, __FILE__, __LINE__ + 1)
            def #{symbol}_default
              instance_eval &@@#{symbol}_default
            end
          RUBY
        else
          class_variable_set("@@#{symbol}_default", default_value)
          class_eval(<<~RUBY, __FILE__, __LINE__ + 1)
            def #{symbol}_default
              @@#{symbol}_default
            end
          RUBY
        end

        class_eval(<<~RUBY, __FILE__, __LINE__ + 1)
          def #{symbol}
            @#{symbol} ||= #{symbol}_default
          end
        RUBY

        class_eval(<<~RUBY, __FILE__, __LINE__ + 1)
          def #{symbol}?
            #{symbol}
          end

          def #{symbol}=(value)
            @#{symbol} = value
          end
        RUBY
      end


      # Enable tracing (false), if it false - tracing disabled
      config_param :enabled, false

      # Service name (with rails Rails.application.class.parent_name else nil)
      config_param(:service_name) { defined?(Rails) ? Rails.application.class.parent_name : nil }

      # Tracing client (:jaeger) - :jaeger, :none or initialized client instance
      config_param :client, :jaeger

      # Tracing client params
      # host: ENV.fetch('JAEGER_HOST') { 'localhost' },
      # port: ENV.fetch('JAEGER_PORT') { 6831 },
      # service_name: service_name
      config_param(:client_params) do
        {
          host: ENV.fetch('JAEGER_HOST') { 'localhost' },
          port: ENV.fetch('JAEGER_PORT') { 6831 },
          service_name: service_name
        }
      end

      # Trace all rack http requests (true)
      # if it tuned off - cross application tracing doesnt work
      config_param :trace_incoming_requests, true

      # Trace all http faraday requests (true)
      # if it tuned off - cross application tracing doesnt work
      config_param :trace_outgoing_requests, true

      # Trace twirp incoming requests (true)
      config_param :trace_twirp_requests, true

      # Trace sql queries (true)
      config_param :trace_sql, true

      # Pass request id from incoming requests to outgoing requests (true)
      config_param :pass_request_id, true

      # Pass request id from incoming requests to outgoing requests (true)
      config_param :request_id_header, 'X-Request-Id'
    end

    def self.configuration
      @cfg
    end

    def self.configure(&_block)
      @cfg = Configuration.new
      yield @cfg
      setup @cfg
    end

    def self.setup(cfg)
      return unless cfg.enabled?

      require_relative 'tracing/client'

      ILove::Tracing::Client.setup cfg

      if cfg.trace_incoming_requests?
        require_relative 'tracing/incoming_requests'

        ILove::Tracing::IncomingRequests.setup cfg
      end

      if cfg.trace_outgoing_requests?
        require_relative 'tracing/outgoing_requests'

        ILove::Tracing::OutgoingRequests.setup cfg
      end

      if cfg.trace_twirp_requests?
        require_relative 'tracing/twirp'

        ILove::Tracing::Twirp.setup cfg
      end

      if cfg.trace_sql?
        require_relative 'tracing/sql'

        ILove::Tracing::Sql.setup cfg
      end

      if cfg.pass_request_id?
        require_relative 'tracing/request_id'

        ILove::Tracing::RequestId.setup cfg
      end

      if cfg.pass_request_id? || cfg.trace_outgoing_requests?
        ILove::Tracing::FaradayMiddleware.setup cfg
      end
    end

    class Error < StandardError; end
  end
end
