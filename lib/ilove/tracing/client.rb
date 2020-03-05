module ILove
  module Tracing
    module Client
      def self.setup(cfg)
        case cfg.client
        when :jaeger
          require('jaeger/client') rescue raise("Add gem 'jaeger-client' to Gemfile")

          OpenTracing.global_tracer = Jaeger::Client.build(cfg.client_params)
        when :none
          nil
        when Symbol
          raise "Unknown client #{cfg.client}"
        else
          OpenTracing.global_tracer = cfg.client
        end
      end
    end
  end
end
