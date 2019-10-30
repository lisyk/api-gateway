# frozen_string_literal: true

require 'dotenv-rails'

module Wellness
  class Engine < ::Rails::Engine
    isolate_namespace Wellness

    config.generators.api_only = true

    config.generators do |g|
      g.test_framework :rspec
    end

    Dotenv::Railtie.load
  end
end
