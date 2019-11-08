# frozen_string_literal: true

require 'dotenv-rails' unless %w[staging production].include?(ENV['RAILS_ENV'])

module Wellness
  class Engine < ::Rails::Engine
    isolate_namespace Wellness

    config.generators.api_only = true

    config.generators do |g|
      g.test_framework :rspec
    end

    Dotenv::Railtie.load if defined? Dotenv
  end
end
