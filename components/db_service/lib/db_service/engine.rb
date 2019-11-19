# frozen_string_literal: true

module DbService
  class Engine < ::Rails::Engine
    isolate_namespace DbService
    config.generators.api_only = true
  end
end
