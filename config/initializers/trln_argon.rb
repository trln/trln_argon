config_file = File.join(Rails.root, "/config/trln_argon_config.yml")

if File.exist?(config_file)

  local_config = YAML.load_file(config_file)[Rails.env]

  TrlnArgon::Engine.configure do |config|
    config.rollup_field           = local_config['rollup_field'] if local_config['rollup_field']
    config.preferred_record_field = local_config['preferred_record_field'] if local_config['preferred_record_field']
    config.preferred_record_value = local_config['preferred_record_value'] if local_config['preferred_record_value']
  end

end
