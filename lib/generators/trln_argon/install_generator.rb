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
      say_status('info', '=================================', :magenta)
      say_status('info', 'Installing Blacklight Range Limit', :magenta)
      say_status('info', '=================================', :magenta)
      generate 'blacklight_range_limit:install'
    end

    # this should match whatever's in trln_argon.gemspec
    def install_gems
      say_status('info', '======================', :magenta)
      say_status('info', 'Adding gems to Gemfile', :magenta)
      say_status('info', '======================', :magenta)

      insert_into_file 'Gemfile', after: 'group :development do' do
        <<~CONTENT
          \n  gem 'better_errors'
          \n  gem 'binding_of_caller'
        CONTENT
      end

      gem 'jquery-rails', '~> 4.6' unless IO.read('Gemfile').include?('jquery-rails')
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
      say_status('info', '============================', :magenta)
      say_status('info', 'Updating the assets manifest', :magenta)
      say_status('info', '============================', :magenta)
      
      prepend_to_file 'app/assets/config/manifest.js', "//= link trln_argon_manifest.js\n"
      prepend_to_file 'app/assets/config/manifest.js', "//= link blacklight/manifest.js\n"
      
      # Check if the line already exists in the file
      manifest_file = 'app/assets/config/manifest.js'
      return if File.readlines(manifest_file).grep(%r{//= link application\.js}).any?
      append_to_file 'app/assets/config/manifest.js', "//= link application.js\n"
    end

    def install_stylesheet
      copy_file 'trln_argon.scss', 'app/assets/stylesheets/trln_argon.scss'
      copy_file 'trln_argon_variables.scss', 'app/assets/stylesheets/trln_argon_variables.scss'
    end

    def inject_javascript_include
      say_status('info', '==============================', :magenta)
      say_status('info', 'Injecting TRLN Argon JS assets', :magenta)
      say_status('info', '==============================', :magenta)
      return unless File.exist?('app/assets/javascripts/application.js')
      return if IO.read('app/assets/javascripts/application.js').include?('trln_argon')

      insert_into_file 'app/assets/javascripts/application.js', after: '//= require blacklight/blacklight' do
        "\n//= require trln_argon/trln_argon\n"
      end
    end

    # BL8's Sprockets asset generator only injects jQuery for Bootstrap 4
    # so we need to explicitly add it when using Bootstrap 5
    # https://github.com/projectblacklight/blacklight/blob/release-8.x/lib/generators/blacklight/assets/sprockets_generator.rb
    def inject_jquery
      say_status('info', '================', :magenta)
      say_status('info', 'Injecting jQuery', :magenta)
      say_status('info', '================', :magenta)
      return unless File.exist?('app/assets/javascripts/application.js')
      insert_into_file 'app/assets/javascripts/application.js', after: '//= require rails-ujs' do
        <<~CONTENT
          \n//= require jquery3
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
        <<~CONTENT
          \n  # Enable BetterErrors to work in Docker

            if defined?(BetterErrors) && Rails.env.development?
              # Allow private subnets as defined by RFC1918
              BetterErrors::Middleware.allow_ip! '10.0.0.0/8'
              BetterErrors::Middleware.allow_ip! '172.16.0.0/12'
              BetterErrors::Middleware.allow_ip! '192.168.0.0/16'
            end
        CONTENT
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

    def setup_application_scss
      say_status('info', '===========================', :magenta)
      say_status('info', 'Setting up application.scss', :magenta)
      say_status('info', '===========================', :magenta)
      insert_into_file 'app/assets/stylesheets/application.scss' do
        <<~CONTENT
          @import 'trln_argon';
        CONTENT
      end
    end

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
