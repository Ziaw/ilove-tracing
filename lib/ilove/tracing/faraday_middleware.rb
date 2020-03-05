module ILove
  module Tracing
    module FaradayMiddleware
      @@active_middleware = Set.new

      def self.active_middleware
        @@active_middleware
      end

      def self.add_active_middleware(middleware)
        @@active_middleware << middleware
      end

      module FaradayConnectionOptions
        def new_builder(block)
          super.tap do |builder|
            ILove::Tracing::FaradayMiddleware.active_middleware.each do |middleware|
              builder.insert(0, middleware)
            end
          end
        end
      end

      def self.setup(cfg)
        return if active_middleware.empty?
        raise 'Faraday is not defined, can not add required outgoing middleware' unless defined?(Faraday)

        Faraday::ConnectionOptions.prepend(FaradayConnectionOptions)
      end
    end
  end
end
