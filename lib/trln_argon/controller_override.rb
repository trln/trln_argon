module TrlnArgon
  module ControllerOverride
    extend ActiveSupport::Concern

    included do

      # TRLN Argon CatalogController configurations
      configure_blacklight do |config|
        config.default_per_page = 20
      end

    end

  end
end
