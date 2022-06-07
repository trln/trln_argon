module BookmarksHelper
  def bookmarks_query(bookmark_ids)
    !bookmark_ids.empty? ? "id:(#{bookmark_ids.join(' OR ')})" : ''
  end
end
