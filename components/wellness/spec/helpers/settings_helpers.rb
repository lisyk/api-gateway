module SettingsHelpers
  def settings_yaml
    YAML.safe_load(
        File.read(
            File.expand_path(File.join('..', '..', '..', '..', 'config', 'settings', 'test.yml'), __dir__)
        )
    ).to_json
  end

  def route_settings
    JSON.parse(settings_yaml, object_class: OpenStruct)
  end
end