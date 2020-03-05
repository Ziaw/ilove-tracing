# I love tracing

Help to trace rack based applications and microservices. Create opentracing spans on:
 - [Rack http requests](#tracing-rack-http-requests)
 - [ActiveRecord sql](#tracing-activerecord-sql)
 - [Twrip service calls](#tracing-twrip_rails-service-calls)
 - [Faraday outgoing requests](#tracing-faraday-outgoing-requests)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ilove-tracing'
gem 'opentracing'

gem 'jaeger-client' # or other opentracing client implementation
```

And then execute:

    $ bundle

## Usage

Create and customize the initializer file:

```sh
$ rails g tracing:init
```

This creates `initializers/ilove-tracing.rb` file. 

_N.B. If you not use Rails - copy it from gem sources 
`cp $(bundle show ilove-tracing)/lib/generators/tracing/init/templates/ilove_tracing.rb ./`_ 

## Tracing Rack http requests

Tracer creates opentracing span named `incoming http request` with parent of incoming http context.

## Tracing ActiveRecord SQL

Creates span of all executed queries named `sql.active_record`. Tags sql.name, sql.statement, sql.statement_name.

## Tracing twrip_rails service calls

Instrument all twirp services mounted by twirp_rails. Creates span named `twirp call` on incoming twirp calls. 
Tags: `service`, `method`. 

To trace twirp services without twirp_rails call 
```ruby
require 'ilove/tracing/twirp.rb'

ILove::Tracing::Twirp.trace_service(service)
```

## Tracing faraday outgoing requests

Instrument all faraday outgoing requests. Creates span named `outgoing http request`. 
Inject active span to request headers. 
Tags: `url`, `method`. 

_N.B. This option uses monkey patch of `Faraday::ConnectionOptions` to inject middleware to all faraday 
(and twirp clients) requests._

## Pass request_id header from incoming requests to outgoing requests.

If this options turned on (default if `config.enabled?`) then header `X-Request-Id` from incoming http requests

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/severgroup-tt/ilove-tracing. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ilove::Tracing project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ilove-tracing/blob/master/CODE_OF_CONDUCT.md).
