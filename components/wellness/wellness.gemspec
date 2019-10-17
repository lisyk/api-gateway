# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'wellness/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'wellness'
  spec.version     = Wellness::VERSION
  spec.authors     = ['Bitwerx/lisyk']
  spec.email       = ['sergey.liskovoy@gmail.com']
  spec.homepage    = 'https://github.com/vippetcare/api-gateway'
  spec.summary     = 'WellnessPlans API Engine.'
  spec.description = 'WellnessPlans API Engine.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'config'
  spec.add_dependency 'faraday', '~> 0.15.4'
  spec.add_dependency 'rails', '~> 6.0.0'

  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'rails-controller-testing'
  spec.add_development_dependency 'rspec-rails', '~> 3.8'
  spec.add_development_dependency 'vcr', '~> 3.0'
  spec.add_development_dependency 'webmock'
end
