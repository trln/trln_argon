class BookmarksController < CatalogController
  include Blacklight::Bookmarks
  include TrlnArgon::BookmarksControllerBehavior
end
