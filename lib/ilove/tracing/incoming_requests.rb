module ILove
  module Tracing
    module IncomingRequests
      class TraceRackMiddleware
        def initialize(app)
          @app = app
        end

        def call(env)
          extracted_ctx = OpenTracing.global_tracer.extract(OpenTracing::FORMAT_RACK, env)
          span = OpenTracing.start_span('incoming http request', child_of: extracted_ctx)
          scope = OpenTracing.scope_manager.activate span

          @app.call(env)
        ensure
          scope.close
        end
      end


      def self.setup(cfg)
        raise 'incoming requests tracing requires rails' unless defined?(Rails)

        Rails.application.middleware.unshift TraceRackMiddleware
      end
    end
  end
end
