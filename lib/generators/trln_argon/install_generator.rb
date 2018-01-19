require 'rails/generators'

module TrlnArgon
  class Install < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Install TRLN Argon Engine'

    def verify_blacklight_installed
      return if IO.read('app/controllers/application_controller.rb').include?('include Blacklight::Controller')
      raise 'Install Blacklight before installing TRLN Argon.'
    end

    def run_dependency_generators
      generate 'blacklight_hierarchy:install'
    end

    def install_gems
      return if IO.read('Gemfile').include?('better_errors')
      gem 'better_errors', '2.1.1'
    end

    def install_configuration_files
      copy_file 'local_env.yml', 'config/local_env.yml'
      copy_file 'trln_argon.yml', 'config/trln_argon.yml'
      copy_file 'solr_field_overrides.yml', 'config/solr_field_overrides.yml'
    end

    def copy_asset_files
      copy_file 'trln_argon.js', 'app/assets/javascripts/trln_argon_application.js'
    end

    def install_search_builders
      copy_file 'search_builders/trln_argon_search_builder.rb', 'app/models/trln_argon_search_builder.rb'
      copy_file 'search_builders/local_search_builder.rb', 'app/models/local_search_builder.rb'
      copy_file 'search_builders/consortium_search_builder.rb', 'app/models/consortium_search_builder.rb'
    end

    def install_helpers
      copy_file 'helpers/catalog_helper.rb', 'app/helpers/catalog_helper.rb'
      copy_file 'helpers/blacklight_helper.rb', 'app/helpers/blacklight_helper.rb'
      copy_file 'helpers/trln_argon_helper.rb', 'app/helpers/trln_argon_helper.rb'
      copy_file 'helpers/render_constraints_helper.rb', 'app/helpers/render_constraints_helper.rb'
      copy_file 'helpers/hierarchy_helper.rb', 'app/helpers/hierarchy_helper.rb'
    end

    def install_stylesheet
      copy_file 'trln_argon.scss', 'app/assets/stylesheets/trln_argon.scss'
    end

    def inject_local_env_loader
      return if IO.read('app/controllers/catalog_controller.rb').include?('TrlnArgon')
      insert_into_file 'app/controllers/catalog_controller.rb', after: 'include Blacklight::Marc::Catalog' do
        "\n\n  # CatalogController behavior and configuration for TrlnArgon"\
        "\n  include TrlnArgon::ControllerOverride\n"
      end
    end

    def inject_item_deserializer
      solrdoc = 'app/models/solr_document.rb'
      return if IO.read(solrdoc).include?('TrlnArgon')
      insert_into_file solrdoc, before: 'class SolrDocument' do
        "\nrequire 'trln_argon'\n\n"
      end
      insert_into_file solrdoc, after: 'include Blacklight::Solr::Document' do
        "\n  include TrlnArgon::ItemDeserializer\n"
      end
    end

    def inject_solr_document_behaviors
      solrdoc = 'app/models/solr_document.rb'
      return if IO.read(solrdoc).include?('TrlnArgon::SolrDocument')
      insert_into_file solrdoc, after: 'include Blacklight::Solr::Document' do
        "\n  include TrlnArgon::SolrDocument\n"
      end
    end

    def inject_into_dev_env
      return if IO.read('config/environments/development.rb').include?('BetterErrors')
      insert_into_file 'config/environments/development.rb', after: 'Rails.application.configure do' do
        "\n\n  BetterErrors::Middleware.allow_ip! \"10.0.2.2\" if defined? BetterErrors && Rails.env == :development\n"
      end
    end

    # rubocop:disable MethodLength
    def inject_into_solr_document
      line_to_check = 'SolrDocument.repository.blacklight_config.document_solr_path'
      return if IO.read('app/models/solr_document.rb').include?(line_to_check)
      insert_into_file 'app/models/solr_document.rb', after: 'include Blacklight::Solr::Document' do
        "\n\n  # This is needed so that SolrDocument.find will work correctly"\
        "\n  # from the Rails console with our Solr configuration."\
        "\n  # Otherwise, it tries to use the non-existent document request handler."\
        "\n  SolrDocument.repository.blacklight_config.document_solr_path = :document"\
        "\n  SolrDocument.repository.blacklight_config.document_solr_request_handler = nil"\
        "\n  SolrDocument.use_extension(TrlnArgon::Document::Ris)"
      end
    end

    def inject_catalog_controller_overrides
      return if IO.read('config/application.rb').include?('local_env.yml')
      insert_into_file 'config/application.rb', after: 'class Application < Rails::Application' do
        "\n\n  config.before_configuration do"\
        "\n      env_file = File.join(Rails .root, 'config', 'local_env.yml')"\
        "\n      if File.exists?(env_file)"\
        "\n        YAML.load_file(env_file).each { |key, value| ENV[key.to_s] = value }"\
        "\n      end"\
        "\n    end\n"
      end
    end

    def remove_default_blacklight_configs # rubocop:disable Metrics/MethodLength
      # For multi line fields
      fields_to_remove = [/ +config.add_facet_field 'example_query_facet_field'[\s\S]+?}\n[ ]+}/,
                          / +config.add_search_field\([\s\S]+?end/]

      fields_to_remove.each do |remove_marker|
        gsub_file('app/controllers/catalog_controller.rb', /#{remove_marker}/, '')
      end

      # For single line fields
      fields_to_remove = [/ +config.index.title_field +=.+?$\n*/,
                          / +config.index.display_type_field +=.+?$\n*/,
                          / +config.add_facet_field +'.+?$\n*/,
                          / +config.add_index_field +'.+?$\n*/,
                          / +config.add_show_field +'.+?$\n*/,
                          / +config.add_search_field +'.+?$\n*/,
                          / +config.add_sort_field +'.+?$\n*/]

      fields_to_remove.each do |remove_marker|
        gsub_file('app/controllers/catalog_controller.rb', /#{remove_marker}/, '')
      end
    end

    def inject_search_builder_behavior
      return if IO.read('app/models/search_builder.rb').include?('TrlnSearchBuilderBehavior')
      insert_into_file 'app/models/search_builder.rb', after: 'include Blacklight::Solr::SearchBuilderBehavior' do
        "\n  include BlacklightAdvancedSearch::AdvancedSearchBuilder"\
        "\n  include TrlnArgon::TrlnSearchBuilderBehavior"\
        "\n\n  self.default_processor_chain += [:add_advanced_parse_q_to_solr, :add_advanced_search_to_solr]\n"
      end
    end
  end
end
