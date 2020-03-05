module ILove
  module Tracing
    module Sql
      def self.setup(_cfg)
        raise 'Cannot trace sql without ActiveSupport' unless defined?(::ActiveSupport)

        ActiveSupport::Notifications.subscribe('sql.active_record') do |_name, start, finish, _id, payload|
          span = OpenTracing.start_span 'sql.active_record',
                                        start_time: start,
                                        child_of: OpenTracing.active_span,
                                        tags: {
                                          'sql.statement' => payload[:sql],
                                          'sql.statement_name' => payload[:statement_name],
                                          'sql.name' => payload[:name]
                                        }

          span.finish end_time: finish
        end
      end
    end
  end
end
