# frozen_string_literal: true

module SettingsHelpers
  def settings_yaml
    file_path = File.expand_path(File.join('..', '..', '..', '..', 'config', 'settings', 'test.yml'), __dir__)
    YAML.safe_load(File.read(file_path)).to_json
  end

  def route_settings
    JSON.parse(settings_yaml, object_class: OpenStruct)
  end
end
