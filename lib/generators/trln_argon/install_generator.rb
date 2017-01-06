require 'rails/generators'

module TrlnArgon
  class Install < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    desc "Install TRLN Catalog"

    def verify_blacklight_installed
      if !IO.read('app/controllers/application_controller.rb').include?('include Blacklight::Controller')
         raise "Install Blacklight before installing TRLN Argon."
      end
    end

    def install_configuration_field
      copy_file "trln_argon_config.yml", "config/trln_argon_config.yml"
    end

    def install_search_builder
      copy_file "trln_search_builder.rb", "app/models/trln_search_builder.rb"
    end

    def inject_catalog_controller_overrides
      unless IO.read("app/controllers/catalog_controller.rb").include?('TrlnArgon')

        insert_into_file "app/controllers/catalog_controller.rb", :after => "include Blacklight::Marc::Catalog" do
          "\n\n  # CatalogController behavior and configuration for TrlnArgon"\
          "\n  include TrlnArgon::ControllerOverride\n"
        end

        insert_into_file "app/controllers/catalog_controller.rb", :after => "configure_blacklight do |config|" do
          "\n\n    config.search_builder_class = TrlnSearchBuilder\n"
        end
      end
    end

  end
end
