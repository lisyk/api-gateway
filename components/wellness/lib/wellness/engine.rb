# frozen_string_literal: true
module Wellness
  class Engine < ::Rails::Engine
   # isolate_namespace Wellness
    config.generators.api_only = true
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
