class BookmarksController < CatalogController
  include Blacklight::Bookmarks
  include TrlnArgon::BookmarksControllerBehavior
  include BookmarksHelper

  # blacklight 7 will try, in default configuration to POST any request
  # which is blocked by our Solr configuration, so we need to ensure
  # our requests are done via GET
  # rubocop:disable Layout/LineLength
  def index
    @bookmarks = token_or_current_or_guest_user.bookmarks
    bookmark_ids = @bookmarks.collect { |b| b.document_id.to_s }
    
    if bookmark_ids.empty?
      @response = Blacklight::Solr::Response.new({},{})
      @document_list = []
    else
      query_params = {
        q: bookmarks_query(bookmark_ids),
        defType: 'lucene',
        rows: bookmark_ids.count
      }
      # search_service.fetch does this internally (7.25)
      @response = search_service.repository.search(query_params)
      @document_list = ActiveSupport::Deprecation::DeprecatedObjectProxy.new(@response.documents, 'The @document_list instance variable is now deprecated and will be removed in Blacklight 8.0')
    end

    respond_to do |format|
      format.html {}
      format.rss  { render layout: false }
      format.atom { render layout: false }

      additional_response_formats(format)
      document_export_formats(format)
    end
  end
  # rubocop:enable Layout/LineLength
end
