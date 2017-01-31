config_file = File.join(Rails.root, "/config/trln_argon_config.yml")

def apply_local_config (config, field)
  config[field] if config[field]
end

if File.exist?(config_file)

  local_config = YAML.load_file(config_file)[Rails.env]

  TrlnArgon::Engine.configure do |config|
    config.rollup_field                  = apply_local_config(local_config, 'rollup_field')
    config.preferred_record_field        = apply_local_config(local_config, 'preferred_record_field')
    config.preferred_record_value        = apply_local_config(local_config, 'preferred_record_value')
    config.local_institution             = apply_local_config(local_config, 'local_institution')
    config.local_records_field           = apply_local_config(local_config, 'local_records_field')
    config.local_records_values          = apply_local_config(local_config, 'local_records_values')
    config.apply_local_filter_by_default = apply_local_config(local_config, 'apply_local_filter_by_default')
    config.application_name              = apply_local_config(local_config, 'application_name')
  end

end
