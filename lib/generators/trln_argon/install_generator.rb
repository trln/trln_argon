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
      copy_file "trln_argon_config.yml", 'config/trln_argon_config.yml'
    end

  end
end