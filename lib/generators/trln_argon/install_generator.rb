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
      generate 'blacklight_range_limit:install'
    end

    # this should match whatever's in trln_argon.gemspec
    def install_gems
      return if IO.read('Gemfile').include?('better_errors')
      gem 'better_errors', '~> 2.9.1'
    end

    def install_configuration_files
      copy_file 'local_env.yml', 'config/local_env.yml'
      copy_file 'solr_field_overrides.yml', 'config/solr_field_overrides.yml'
    end

    def install_trln_controller_file
      copy_file 'trln_controller.rb', 'app/controllers/trln_controller.rb'
    end

    def install_solr_document_behaviors
      copy_file 'solr_document_behavior.rb', 'app/models/concerns/solr_document_behavior.rb'
    end

    def install_solr_document
      # remove Blacklight installed solr_document.rb
      File.delete('app/models/solr_document.rb')
      copy_file 'solr_document.rb', 'app/models/solr_document.rb'
    end

    def install_trln_solr_document
      copy_file 'trln_solr_document.rb', 'app/models/trln_solr_document.rb'
    end

    def load_helpers_in_host_application
      insert_into_file 'app/controllers/application_controller.rb',
                       after: 'layout \'blacklight\'' do
        "\n  helper TrlnArgon::Engine.helpers" \
        "\n  skip_after_action :discard_flash_if_xhr"
      end
    end

    def update_assets_manifest
      prepend_to_file 'app/assets/config/manifest.js', "//= link trln_argon_manifest.js\n"
    end

    def install_stylesheet
      copy_file 'trln_argon.scss', 'app/assets/stylesheets/trln_argon.scss'
      copy_file 'trln_argon_variables.scss', 'app/assets/stylesheets/trln_argon_variables.scss'
    end

    # TODO: revisit this; probably not necessary for BL8
    # BL7 started precompiling blacklight/blacklight.js
    # We need this file without the autocomplete parts so
    # we can use our own.  This autogenerates the above file
    # in the target application as a set of requires, based
    # on the contents of the /app/javascript/blacklight directory
    # in the Blacklight gem, excluding autocomplete.
    def override_compiled_blacklight_javascript
      TrlnArgon::Utilities.new.repackage_blacklight_javascript
    end

    def insert_into_assets_initializer
      TrlnArgon::Utilities.new.install_blacklight_asset_path
    end

    # Inject jQuery into the importmap, to ease transition to BL8
    # TODO: Might we retire jQuery entirely in favor of vanilla ES6 & Stimulus?
    # TODO: We probably need to revise some existing jQuery to work with
    # modern versions, e.g., $('#element').click() may no longer work...
    # and/or adjust the max version of jQuery we're using.
    def inject_jquery
      jquery_version = "3.7.1"
      puts "Injecting jQuery #{jquery_version}"
      append_to_file 'config/importmap.rb' do
        <<~CONTENT
          pin "jquery", to: "https://cdn.jsdelivr.net/npm/jquery@#{jquery_version}/dist/jquery.js"
        CONTENT
      end

      append_to_file 'app/javascript/application.js' do
        <<~CONTENT
          import "jquery"
        CONTENT
      end
    end

    def inject_javascript_imports
      puts "Injecting trln_argon javascript"
      append_to_file 'config/importmap.rb' do
        <<~CONTENT
          pin_all_from "trln_argon", under: "trln_argon"
        CONTENT
      end

      append_to_file 'app/javascript/application.js' do
        <<~CONTENT
          import "trln_argon"
        CONTENT
      end
    end

    def inject_local_env_loader
      return if IO.read('app/controllers/catalog_controller.rb').include?('TrlnArgon')
      insert_into_file 'app/controllers/catalog_controller.rb', after: 'include Blacklight::Catalog' do
        "\n\n  # CatalogController behavior and configuration for TrlnArgon"\
        "\n  include TrlnArgon::ControllerOverride\n"
      end
    end

    def inject_into_dev_env
      return if IO.read('config/environments/development.rb').include?('BetterErrors')
      insert_into_file 'config/environments/development.rb', after: 'Rails.application.configure do' do
        "\n\n  require 'socket'\n" \
        "  begin\n" \
        "    local_ip = IPSocket.getaddress(Socket.gethostname)\n" \
        "  rescue\n" \
        "    local_ip = \"127.0.0.1\"\n" \
        "  end\n" \
        "  BetterErrors::Middleware.allow_ip! local_ip if defined?(BetterErrors) && Rails.env.development?\n"
      end
    end

    def inject_catalog_controller_overrides
      return if IO.read('config/application.rb').include?('local_env.yml')
      insert_into_file 'config/application.rb', after: 'class Application < Rails::Application' do
        "\n\n  config.before_configuration do"\
        "\n      env_file = File.join(Rails .root, 'config', 'local_env.yml')"\
        "\n      if File.exist?(env_file)"\
        "\n        YAML.load_file(env_file).each { |key, value| ENV[key.to_s] = value }"\
        "\n      end"\
        "\n    end\n"
      end
    end

    # rubocop:disable Style/StringConcatenation
    def remove_default_blacklight_configs
      # For multi line fields
      fields_to_remove = [/ +config.add_facet_field 'example_query_facet_field'[\s\S]+?}\n[ ]+}/,
                          / +config.add_search_field\([\s\S]+?end/]

      fields_to_remove.each do |remove_marker|
        gsub_file('app/controllers/catalog_controller.rb', /#{remove_marker}/, '')
      end

      # For single line fields
      fields_to_remove = [/(\s+)(config.index.title_field +=.+?)$\n*/,
                          /(\s+)(config.index.display_type_field +=.+?)$\n*/,
                          /(\s+)(config.add_facet_field\b.+?)$\n*/,
                          /(\s+)(config.add_index_field.+?)$\n*/,
                          /(\s+)(config.add_show_field.+?$)\n*/,
                          /(\s+)(config.add_search_field.+?)$\n*/,
                          /(\s+)(config.add_sort_field.+?)$\n*/,
                          /(\s+)(config.add_show_tools_partial.+?)$\n*/]

      fields_to_remove.each do |remove_marker|
        gsub_file('app/controllers/catalog_controller.rb', remove_marker, '\1# \2' + "\n")
      end
    end
    # rubocop:enable Style/StringConcatenation

    def inject_search_builder_behavior
      return if IO.read('app/models/search_builder.rb').include?('TrlnArgon::ArgonSearchBuilder')
      insert_into_file 'app/models/search_builder.rb', after: 'include Blacklight::Solr::SearchBuilderBehavior' do
        "\n  include BlacklightAdvancedSearch::AdvancedSearchBuilder"\
        "\n  include TrlnArgon::ArgonSearchBuilder\n"\
        "\n\n  self.default_processor_chain += [:add_advanced_search_to_solr]\n"
      end
    end

    # TODO: revisit this; Turbolinks was replaced by Turbo in Rails 7
    def remove_turbolinks # via http://codkal.com/rails-how-to-remove-turbolinks/
      gsub_file('Gemfile', "gem 'turbolinks',", '')
      if File.exist?('app/assets/javascripts/application.js')
        gsub_file('app/assets/javascripts/application.js', '//= require turbolinks', '')
      end
      gsub_file('app/views/layouts/application.html.erb', "<%= stylesheet_link_tag 'application', media: 'all',
        'data-turbolinks-track': 'reload' %>", '')
      gsub_file('app/views/layouts/application.html.erb', "<%= javascript_include_tag 'application',
        'data-turbolinks-track': 'reload' %>", '')
    end

    def mount_argon_routes
      return if IO.read('config/routes.rb').include?('mount TrlnArgon::Engine')
      insert_into_file 'config/routes.rb', after: "mount Blacklight::Engine => '/'" do
        "\n  mount TrlnArgon::Engine => '/'\n"
      end
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

    def inject_trln_argon_user
      file = 'app/models/user.rb'
      insert_into_file(file, after: 'include Blacklight::User') do
        "\n  include TrlnArgon::User\n"
      end
    end

    # Blacklight 7.25.1 and higher allow overriding viewcomponent
    # templates, but only for applications, not engines; this
    # copies any overridden template components into the application
    def copy_blacklight_component_templates
      util = TrlnArgon::Utilities.new
      search_path = File.expand_path('../../..', __dir__)
      util.find_view_component_template_overrides(search_path).each do |f|
        dest = File.join(destination_root, f[:partial])
        if File.exist?(dest)
          puts "Not overwriting #{dest} as it already exists"
        else
          puts "Ensure #{File.dirname(dest)}"
          FileUtils.mkdir_p(File.dirname(dest))
          puts "Copying #{f[:full]} to #{dest}"
          FileUtils.copy_file(f[:full], dest)
        end
      end
    end
  end
end
