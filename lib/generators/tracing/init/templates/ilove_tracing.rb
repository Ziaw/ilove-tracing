ILove::Tracing.configure do |config|
  # Enable tracing (default false - tracing disabled)
  config.enabled = ENV['JAEGER_HOST'].present?

  # Service name (with rails Rails.application.class.parent_name else nil)
  # config.service_name = Rails.application.class.parent_name

  # Tracing client :jaeger, :none or initialized client instance (default :jaeger)
  # config.client = :jaeger

  # Tracing client params (client initializer arguments)
  # config.client_params do
  #   {
  #     host: ENV.fetch('JAEGER_HOST') { 'localhost' },
  #     port: ENV.fetch('JAEGER_PORT') { 6831 },
  #     service_name: config.service_name
  #   }
  # end

  # Trace all rack http requests (default true)
  # if it tuned off - cross application tracing doesnt work
  # config.trace_incoming_requests = true

  # Trace all http faraday requests (default true)
  # if it tuned off - cross application tracing doesnt work
  # config.trace_outgoing_requests = true

  # Trace twirp incoming requests (default true)
  # config.trace_twirp_requests = true

  # Trace sql queries (default true)
  # config.trace_sql = true

  # Pass request id from incoming requests to outgoing requests (default true)
  # config.pass_request_id = true

  # request id header name (default 'X-Request-Id')
  # config.request_id_header = 'X-Request-Id'
end
