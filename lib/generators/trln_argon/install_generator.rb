require 'rails/generators'

module TrlnArgon
  class Install < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    desc "Install TRLN Argon Engine"

    def verify_blacklight_installed
      if !IO.read('app/controllers/application_controller.rb').include?('include Blacklight::Controller')
         raise "Install Blacklight before installing TRLN Argon."
      end
    end

    def install_configuration_files
      copy_file "local_env.yml", "config/local_env.yml"
      copy_file "trln_argon.yml", "config/trln_argon.yml"
    end

    def install_search_builders
      copy_file "search_builders/trln_argon_search_builder.rb", "app/models/trln_argon_search_builder.rb"
      copy_file "search_builders/local_search_builder.rb", "app/models/local_search_builder.rb"
      copy_file "search_builders/consortium_search_builder.rb", "app/models/consortium_search_builder.rb"
    end

    def install_helpers
      copy_file "helpers/catalog_helper.rb", "app/helpers/catalog_helper.rb"
      copy_file "helpers/blacklight_helper.rb", "app/helpers/blacklight_helper.rb"
      copy_file "helpers/trln_argon_helper.rb", "app/helpers/trln_argon_helper.rb"
    end

    def install_stylesheet
      copy_file "trln_argon.scss", "app/assets/stylesheets/trln_argon.scss"
    end

    def inject_local_env_loader
      unless IO.read("app/controllers/catalog_controller.rb").include?('TrlnArgon')
        insert_into_file "app/controllers/catalog_controller.rb", :after => "include Blacklight::Marc::Catalog" do
          "\n\n  # CatalogController behavior and configuration for TrlnArgon"\
          "\n  include TrlnArgon::ControllerOverride\n"
        end
      end
    end

    def inject_into_dev_env
      unless IO.read("config/environments/development.rb").include?("BetterErrors")
        insert_into_file "config/environments/development.rb", :after => "Rails.application.configure do" do
          "\n\n  BetterErrors::Middleware.allow_ip! \"10.0.2.2\" if defined? BetterErrors && Rails.env == :development\n"
        end
      end
    end

    def inject_catalog_controller_overrides
      unless IO.read("config/application.rb").include?('local_env.yml')
        insert_into_file "config/application.rb", :after => "class Application < Rails::Application" do
          "\n\n  config.before_configuration do"\
          "\n      env_file = File.join(Rails .root, 'config', 'local_env.yml')"\
          "\n      if File.exists?(env_file)"\
          "\n        YAML.load_file(env_file).each { |key, value| ENV[key.to_s] = value }"\
          "\n      end"\
          "\n    end\n"
        end
      end
    end

    def remove_default_blacklight_configs
      #For multi line fields
      fields_to_remove = [/ +config.add_facet_field 'example_query_facet_field'[\s\S]+?}\n[ ]+}/,
                               / +config.add_search_field\([\s\S]+?end/
      ]

      fields_to_remove.each do |remove_marker|
        gsub_file("app/controllers/catalog_controller.rb", /#{remove_marker}/, "")
      end

      #For single line fields
      fields_to_remove = [/ +config.index.title_field +=.+?$\n*/,
                               / +config.index.display_type_field +=.+?$\n*/,
                               / +config.add_facet_field +'.+?$\n*/,
                               / +config.add_index_field +'.+?$\n*/,
                               / +config.add_show_field +'.+?$\n*/,
                               / +config.add_search_field +'.+?$\n*/,
                               / +config.add_sort_field +'.+?$\n*/
      ]

      fields_to_remove.each do |remove_marker|
        gsub_file("app/controllers/catalog_controller.rb", /#{remove_marker}/, "")
      end
    end

    def inject_search_builder_behavior
      unless IO.read("app/models/search_builder.rb").include?('TrlnSearchBuilderBehavior')
        insert_into_file "app/models/search_builder.rb", :after => "include Blacklight::Solr::SearchBuilderBehavior" do
          "\n  include BlacklightAdvancedSearch::AdvancedSearchBuilder"\
          "\n  include TrlnArgon::TrlnSearchBuilderBehavior"\
          "\n\n  self.default_processor_chain += [:add_advanced_parse_q_to_solr, :add_advanced_search_to_solr]\n"
        end
      end
    end

  end
end
