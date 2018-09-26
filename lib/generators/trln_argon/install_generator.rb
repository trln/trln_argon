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
      generate 'blacklight_range_limit:install'
    end

    def install_gems
      return if IO.read('Gemfile').include?('better_errors')
      gem 'better_errors', '2.1.1'
    end

    def install_configuration_files
      copy_file 'local_env.yml', 'config/local_env.yml'
      copy_file 'solr_field_overrides.yml', 'config/solr_field_overrides.yml'
    end

    def load_helpers_in_host_application
      insert_into_file 'app/controllers/application_controller.rb',
                       after: 'protect_from_forgery with: :exception' do
        "\n  helper TrlnArgon::Engine.helpers"
      end
    end

    def install_stylesheet
      copy_file 'trln_argon.scss', 'app/assets/stylesheets/trln_argon.scss'
      copy_file 'trln_argon_variables.scss', 'app/assets/stylesheets/trln_argon_variables.scss'
    end

    def inject_javascript_include
      return if IO.read('app/assets/javascripts/application.js').include?('trl_argon')
      insert_into_file 'app/assets/javascripts/application.js', after: '//= require blacklight/blacklight' do
        "\n//= require trln_argon/trln_argon\n"
      end
    end

    def inject_local_env_loader
      return if IO.read('app/controllers/catalog_controller.rb').include?('TrlnArgon')
      insert_into_file 'app/controllers/catalog_controller.rb', after: 'include Blacklight::Catalog' do
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
        "\n  SolrDocument.repository.blacklight_config.document_solr_request_handler = nil"
      end
    end

    def inject_ris_action
      line_to_check = 'SolrDocument.use_extension(TrlnArgon::DocumentExtensions::Ris)'
      return if IO.read('app/models/solr_document.rb').include?(line_to_check)
      insert_into_file 'app/models/solr_document.rb',
                       after: 'SolrDocument.repository.blacklight_config.document_solr_request_handler = nil' do
        "\n  SolrDocument.use_extension(TrlnArgon::DocumentExtensions::Ris)\n"
      end
    end

    def inject_open_url_ctx_kev_action
      line_to_check = 'SolrDocument.use_extension(TrlnArgon::DocumentExtensions::OpenurlCtxKev)'
      return if IO.read('app/models/solr_document.rb').include?(line_to_check)
      insert_into_file 'app/models/solr_document.rb',
                       after: 'SolrDocument.use_extension(TrlnArgon::DocumentExtensions::Ris)' do
        "\n  SolrDocument.use_extension(TrlnArgon::DocumentExtensions::OpenurlCtxKev)\n"
      end
    end

    def inject_email_action
      line_to_check = 'SolrDocument.use_extension(TrlnArgon::DocumentExtensions::Email)'
      return if IO.read('app/models/solr_document.rb').include?(line_to_check)
      gsub_file 'app/models/solr_document.rb',
                'SolrDocument.use_extension(Blacklight::Document::Email)',
                'SolrDocument.use_extension(TrlnArgon::DocumentExtensions::Email)'
    end

    def inject_sms_action
      line_to_check = 'SolrDocument.use_extension(TrlnArgon::DocumentExtensions::Sms)'
      return if IO.read('app/models/solr_document.rb').include?(line_to_check)
      gsub_file 'app/models/solr_document.rb',
                'SolrDocument.use_extension(Blacklight::Document::Sms)',
                'SolrDocument.use_extension(TrlnArgon::DocumentExtensions::Sms)'
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
      return if IO.read('app/models/search_builder.rb').include?('TrlnArgon::ArgonSearchBuilder')
      insert_into_file 'app/models/search_builder.rb', after: 'include Blacklight::Solr::SearchBuilderBehavior' do
        "\n  include BlacklightAdvancedSearch::AdvancedSearchBuilder"\
        "\n  include TrlnArgon::ArgonSearchBuilder\n"\
        "\n\n  self.default_processor_chain += [:add_advanced_search_to_solr]\n"
      end
    end

    def remove_turbolinks # via http://codkal.com/rails-how-to-remove-turbolinks/
      gsub_file('Gemfile', "gem 'turbolinks',", '')
      gsub_file('app/assets/javascripts/application.js', '//= require turbolinks', '')
      gsub_file('app/views/layouts/application.html.erb', "<%= stylesheet_link_tag 'application', media: 'all',
        'data-turbolinks-track': 'reload' %>", '')
      gsub_file('app/views/layouts/application.html.erb', "<%= javascript_include_tag 'application',
        'data-turbolinks-track': 'reload' %>", '')
    end

    def add_trln_routes
      return if IO.read('config/routes.rb').include?('resource :trln')
      insert_into_file 'config/routes.rb', after: 'concern :searchable, Blacklight::Routes::Searchable.new' do
        "\n  resource :trln, only: [:index], as: 'trln', path: '/trln', controller: 'trln' do"\
        "\n    concerns :searchable"\
        "\n    concerns :range_searchable"\
        "\n  end\n"\
      end
    end

    def add_trln_exportable_routes
      return if IO.read('config/routes.rb').include?('resources :trln_solr_documents')
      insert_into_file('config/routes.rb', after: 'concern :exportable, Blacklight::Routes::Exportable.new') do
        "\n\n  resources :trln_solr_documents, only: [:show], path: '/trln', controller: 'trln' do"\
        "\n    concerns :exportable"\
        "\n  end"
      end
    end

    def comment_out_blacklight_generated_suggest_config
      file = 'app/controllers/catalog_controller.rb'

      gsub_file(file,
                /^\s*config.autocomplete_enabled = true/,
                '    # config.autocomplete_enabled = true')
      gsub_file(file,
                /^\s*config.autocomplete_path = 'suggest'/,
                "    # config.autocomplete_path = 'suggest'")
    end
  end
end
