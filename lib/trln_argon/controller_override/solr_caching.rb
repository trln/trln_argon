# implements caching for certain expensive queries
# where liveness of results is not a top concern.
module SolrCaching
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def cached_catalog_index
    cat_index_cache_key = cache_key('cached_catalog_index')

    (@response, deprecated_document_list) =
      if cat_index_cache_key.present?
        logger.info('index page solr response cache hit')
        Rails.cache.fetch(cat_index_cache_key.to_s, expires_in: solr_cache_exp_time) do
          search_service.search_results
        end
      else
        search_service.search_results
      end

    @document_list = ActiveSupport::Deprecation::DeprecatedObjectProxy.new(deprecated_document_list, 'The @document_list instance variable is deprecated; use @response.documents instead.')

    respond_to do |format|
      format.html { store_preferred_view }
      format.rss  { render layout: false }
      format.atom { render layout: false }
      format.json do
        @presenter = Blacklight::JsonPresenter.new(@response,
                                                   blacklight_config)
      end
      additional_response_formats(format)
      document_export_formats(format)
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/MethodLength
  def cached_advanced_index
    return if request.method == :post

    adv_index_cache_key = cache_key('cached_advanced_index')

    @response =
      if adv_index_cache_key.present?
        logger.info('advanced search page solr response cache hit')
        Rails.cache.fetch(adv_index_cache_key.to_s, expires_in: solr_cache_exp_time) do
          get_advanced_search_facets
        end
      else
        get_advanced_search_facets
      end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def cache_key(cached_request_type)
    return unless cache_solr_response?
    "#{params.fetch('controller', '')}/"\
    "#{params.fetch('action', '')}/"\
    "#{cached_request_type}"
  end

  def cache_solr_response?
    (params.keys - %w[controller action]).empty? &&
      TrlnArgon::Engine.configuration.solr_cache_exp_time.present?
  end

  def solr_cache_exp_time
    num_string, time_unit = TrlnArgon::Engine.configuration.solr_cache_exp_time.split('.')
    num_string.to_i.send(time_unit)
  end
end
