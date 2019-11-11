module DatabaseService
  class Engine < ::Rails::Engine
    isolate_namespace DatabaseService
    config.generators.api_only = true
  end
end
