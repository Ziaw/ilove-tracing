module ILove
  module Tracing
    module Twirp
      def self.setup(cfg)
        raise 'Cannot trace twirp without twirp_rails gem' unless defined?(::TwirpRails)

        ::TwirpRails::Routes::Helper.on_create_service do |service|
          scope = nil # introduce common closure var

          service.before do |_rack_env, env|
            method_name = env[:rpc_method]

            scope = OpenTracing.start_active_span 'twirp call',
                                                  child_of: OpenTracing.active_span,
                                                  tags: { service: service.full_name, method: method_name }
          end

          service.on_error do |err, _env|
            if scope
              scope.span.set_tag :error_code, err.code
              scope.span.set_tag :error_msg, err.msg
              scope.close
              scope = nil
            end
          end

          service.on_success do |_env|
            if scope
              scope.close
              scope = nil
            end
          end

          service.exception_raised do |e, _env|
            if scope
              scope.span.set_tag :exception, e.class.name
              scope.close
              scope = nil
            end
          end
        end
      end
    end
  end
end
