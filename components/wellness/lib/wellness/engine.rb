# frozen_string_literal: true

require 'dotenv-rails' unless %w[staging production].include?(ENV['RAILS_ENV'])

module Wellness
  class Engine < ::Rails::Engine
    isolate_namespace Wellness

    config.generators.api_only = true

    config.generators do |g|
      g.test_framework :rspec
    end

    if defined? Dotenv
      Dotenv::Railtie.load
    end
  end
end
