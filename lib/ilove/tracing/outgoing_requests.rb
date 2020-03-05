require_relative 'faraday_middleware'

module ILove
  module Tracing
    module OutgoingRequests
      class FaradayTraceMiddleware < Faraday::Middleware
        def call(env)
          scope = OpenTracing.start_active_span 'outgoing http request',
                                                child_of: OpenTracing.active_span,
                                                tags: { url: env.url, method: env.method }

          OpenTracing.inject scope.span.context, OpenTracing::FORMAT_RACK, env[:request_headers]

          @app.call(env).on_complete do
            scope.close
          end
        end
      end

      def self.setup(cfg)
        raise 'Cannot trace outgoing request without Faraday' unless defined?(Faraday)

        ILove::Tracing::FaradayMiddleware.add_active_middleware FaradayTraceMiddleware
      end
    end
  end
end
