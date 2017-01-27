class BookmarksController < CatalogController

  include Blacklight::Bookmarks

        # TRLN Argon CatalogController configurations
      configure_blacklight do |config|

        # TODO: Consider making some of this configurabl in trln_argon_config.yml
        config.search_builder_class = ConsortiumSearchBuilder

      end

end
