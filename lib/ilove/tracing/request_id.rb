require_relative 'faraday_middleware'

module ILove
  module Tracing
    module RequestId
      def self.cfg
        @@cfg
      end

      def self.request_id
        Thread.current[:request_id]
      end

      def self.request_id=(val)
        Thread.current[:request_id] = val
      end

      class RequestIdRackMiddleware
        def initialize(app)
          @app = app
        end

        def rack_header_name
          @@rack_header_name ||= 'HTTP_' + ILove::Tracing::RequestId.cfg.request_id_header.gsub(/-/, '_').upcase
        end

        def call(env)
          ILove::Tracing::RequestId.request_id = env[rack_header_name]

          @app.call(env)
        ensure
          ILove::Tracing::RequestId.request_id = nil
        end
      end

      class RequestIdFaradayMiddleware < Faraday::Middleware
        def call(env)
          env.request_headers[ILove::Tracing::RequestId.cfg.request_id_header] = ILove::Tracing::RequestId.request_id

          @app.call(env)
        end
      end

      def self.setup(cfg)
        raise 'pass request id requires rails' unless defined?(::Rails)
        raise 'pass request id requires faraday' unless defined?(::Faraday)

        @@cfg = cfg
        Rails.application.middleware.unshift RequestIdRackMiddleware
        ILove::Tracing::FaradayMiddleware.add_active_middleware RequestIdFaradayMiddleware
      end
    end
  end
end
