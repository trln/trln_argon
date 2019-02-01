def apply_local_configuration(config, config_key)
  return unless ENV.key?(config_key.upcase)

  config.send("#{config_key}=".to_sym, ENV[config_key.upcase])
end

TrlnArgon::Engine.configure do |config|
  apply_local_configuration(config, 'local_institution_code')
  apply_local_configuration(config, 'application_name')
  apply_local_configuration(config, 'refworks_url')
  apply_local_configuration(config, 'root_url')
  apply_local_configuration(config, 'article_search_url')
  apply_local_configuration(config, 'contact_url')
  apply_local_configuration(config, 'feedback_url')
  apply_local_configuration(config, 'sort_order_in_holding_list')
  apply_local_configuration(config, 'number_of_location_facets')
  apply_local_configuration(config, 'number_of_items_index_view')
  apply_local_configuration(config, 'number_of_items_show_view')
  apply_local_configuration(config, 'argon_code_mappings_dir')
  apply_local_configuration(config, 'unc_latest_received_url')

  config.code_mappings = {
    git_url: 'https://github.com/trln/argon_code_mappings',
    git_branch: 'master'
  }

  git_fetcher = TrlnArgon::MappingsGitFetcher.new(
    git_url: config.code_mappings[:git_url],
    repo_base: config.argon_code_mappings_dir
  )
  TrlnArgon::LookupManager.fetcher = git_fetcher
  # do a lookup so the mappings are initialized.
  TrlnArgon::LookupManager.instance.map('ncsu.library.DHHILL')
end
