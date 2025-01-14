class BookmarksController < CatalogController
  include Blacklight::Bookmarks
  include TrlnArgon::BookmarksControllerBehavior
  include BookmarksHelper

  # Blacklight will try, in default configuration to POST any request
  # which is blocked by our Solr configuration, so we need to ensure
  # our requests are done via GET (i.e., don't use search_service.fetch)
  # rubocop:disable Metrics/MethodLength
  def index
    @bookmarks = token_or_current_or_guest_user.bookmarks
    bookmark_ids = @bookmarks.collect { |b| b.document_id.to_s }

    if bookmark_ids.empty?
      @response = Blacklight::Solr::Response.new({}, {})
      @documents = []
    else
      query_params = {
        q: bookmarks_query(bookmark_ids),
        defType: 'lucene',
        rows: bookmark_ids.count
      }
      # search_service.fetch does this internally (7.25)
      @response = search_service.repository.search(query_params)
      @documents = @response.documents
    end

    respond_to do |format|
      format.html {}
      format.rss  { render layout: false }
      format.atom { render layout: false }

      additional_response_formats(format)
      document_export_formats(format)
    end
  end
  # rubocop:enable Metrics/MethodLength

  # Override BL core to query Solr via GET rather than POST
  # for bookmarks tools, e.g., Cite, Email, SMS. See:
  # https://github.com/projectblacklight/blacklight/blob/release-8.x/app/controllers/concerns/blacklight/bookmarks.rb#L27-L31
  # https://github.com/projectblacklight/blacklight/blob/release-8.x/app/controllers/concerns/blacklight/catalog.rb#L115-L122
  # See also: lib/trln_argon/controller_override.rb
  def action_documents
    bookmarks = token_or_current_or_guest_user.bookmarks
    bookmark_ids = bookmarks.collect { |b| b.document_id.to_s }
    query_params = {
      q: bookmarks_query(bookmark_ids),
      defType: 'lucene',
      rows: bookmark_ids.count
    }
    @response = search_service.repository.search(query_params)
    @documents = @response.documents
    raise Blacklight::Exceptions::RecordNotFound if @documents.blank?

    @documents
  end
end
