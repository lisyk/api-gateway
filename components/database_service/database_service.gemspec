$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "database_service/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'database_service'
  spec.version     = DatabaseService::VERSION
  spec.authors     = ['Bitwerx/lisyk']
  spec.email       = ['sergey.liskovoy@gmail.com']
  spec.homepage    = 'https://github.com/vippetcare/api-gateway'
  spec.summary     = 'Postgresql Database service for API gateway.'
  spec.description = 'Postgresql Database service for API gateway'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = 'http://mygemserver.com'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  spec.test_files = Dir['spec/**/*']

  spec.add_dependency "rails", "~> 6.0.0"

  spec.add_development_dependency 'dotenv-rails'
  spec.add_development_dependency 'pg', '>= 0.18', '< 2.0'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'rails-controller-testing'
  spec.add_development_dependency 'rspec-rails', '~> 3.8'
end
