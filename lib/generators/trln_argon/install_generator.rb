require 'rails/generators'

module TrlnArgon
  class Install < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    desc "Install TRLN Catalog"

    def install_configuration_field
      copy_file "trln_argon_config.yml", 'config/trln_argon_config.yml'
    end

  end
end