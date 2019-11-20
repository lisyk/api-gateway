# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# https://github.com/bkeepers/dotenv#rails
gem 'dotenv-rails', groups: [:development, :test]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'airbrake', '~> 9.4'

# Manage environment specific settings
gem 'config'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# Use OpenAPI Rswag for UI/API documentation
gem 'open_api-rswag-api'
gem 'open_api-rswag-ui'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'open_api-rswag-specs'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.8'
  gem 'rubocop', '~> 0.74.0', require: false
  gem 'rubocop-rails'
  gem 'shoulda-matchers'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

#####  API JWT Authentication ##########
gem 'jwt'

#####  API Gateway Engines #############
# Wellness Plans Engine
gem 'wellness', path: 'components/wellness'

# Database service engine. common Api Gateway ActiveRecord Models
gem 'db_service', path: 'components/db_service'

#######################################
