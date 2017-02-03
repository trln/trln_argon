class BookmarksController < CatalogController

  include Blacklight::Bookmarks

    configure_blacklight do |config|

      config.search_builder_class = ConsortiumSearchBuilder

    end

end
