# frozen_string_literal: true

# https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#config
workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3111
environment ENV['RACK_ENV'] || 'development'
