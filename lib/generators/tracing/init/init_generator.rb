module Tracing
  class InitGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    desc 'This generator creates an initializer file at config/initializers'
    def create_initializer_file
      copy_file 'ilove_tracing.rb', 'config/initializers/ilove_tracing.rb'
    end
  end
end
