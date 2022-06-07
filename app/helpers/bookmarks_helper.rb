module BookmarksHelper
  def bookmarks_query(bookmark_ids)
    bookmark_ids.length > 0 ? "id:(#{bookmark_ids.join(' OR ')})" : ""
  end
end
