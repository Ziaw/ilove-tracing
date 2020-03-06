
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ilove/tracing/version'

Gem::Specification.new do |spec|
  spec.name          = 'ilove-tracing'
  spec.version       = ILove::Tracing::VERSION
  spec.authors       = ['Alexandr Zimin']
  spec.email         = ['a.zimin@talenttech.ru']

  spec.summary       = 'Opentracing plugins to instrument rails, twirp_rails, faradey, active_record.'
  spec.description   = 'Opentracing plugins to instrument rails, twirp_rails, faradey, active_record.'
  spec.homepage      = 'http://github.com/severgroup-tt/ilove-tracing'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'http://github.com/severgroup-tt/ilove-tracing'
    spec.metadata['changelog_uri'] = 'http://github.com/severgroup-tt/ilove-tracing/blob/master/CHANGELOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0")
                     .reject { |f| f.match(%r{^(bin|doc|test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rails', '~> 6.0'
  spec.add_development_dependency 'twirp_rails', '~> 0.3.0'
end
