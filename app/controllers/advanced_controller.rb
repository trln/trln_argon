class AdvancedController < CatalogController
  def index
    @response = get_advanced_search_facets unless request.method == :post
  end

  private

  def search_action_url(options = {})
    url_for(options.merge(controller: 'catalog', action: 'index'))
  end

  # rubocop:disable AccessorMethodName
  # Method name is from BL Advanced Search
  def get_advanced_search_facets
    # We want to find the facets available for the current search, but:
    # * IGNORING current query (add in facets_for_advanced_search_form filter)
    # * IGNORING current advanced search facets (remove add_advanced_search_to_solr filter)
    response, = search_results(params) do |search_builder|
      search_builder.except(:add_advanced_search_to_solr).append(:facets_for_advanced_search_form)
    end

    response
  end
end
