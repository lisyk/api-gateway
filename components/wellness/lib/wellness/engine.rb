# frozen_string_literal: true
require 'rubygems'
require 'open_api-rswag-api'
require 'open_api-rswag-ui'
require 'open_api-rswag-specs'
require 'rspec-rails'
module Wellness
  class Engine < ::Rails::Engine
    isolate_namespace Wellness
    config.generators.api_only = true
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
