class BookmarksController < CatalogController
  include Blacklight::Bookmarks

  configure_blacklight do |config|
    config.search_builder_class = RollupOnlySearchBuilder
  end

  def filter_scope_name
    t('trln_argon.scope_name.bookmarks')
  end
end
