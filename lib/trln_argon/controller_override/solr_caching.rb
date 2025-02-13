# Implements caching for certain expensive queries
# where liveness of results is not a top concern.
module SolrCaching
  extend ActiveSupport::Concern

  # We replicate much of core BL's index action here, but add logic
  # around caching the response if it's cacheable. See:
  # https://github.com/projectblacklight/blacklight/blob/release-8.x/app/controllers/concerns/blacklight/catalog.rb#L24-L51
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def cached_catalog_index
    cat_index_cache_key = cache_key('cached_catalog_index')

    @response =
      if cat_index_cache_key.present? && Rails.configuration.action_controller.perform_caching
        cache_state = 'cacheable'
        Rails.cache.fetch(cat_index_cache_key, expires_in: solr_cache_exp_time) do
          cache_state = 'cache miss'
          search_service.search_results
        end
      else # not cacheable
        search_service.search_results
      end

    log_cache_state(cache_state, cat_index_cache_key)

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
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def cached_advanced_index
    return if request.method == :post

    adv_index_cache_key = cache_key('cached_advanced_index')

    @response =
      if adv_index_cache_key.present? && Rails.configuration.action_controller.perform_caching
        cache_state = 'cacheable'
        Rails.cache.fetch(adv_index_cache_key, expires_in: solr_cache_exp_time) do
          cache_state = 'cache miss'
          advanced_search_form_data
        end
      else # not cacheable
        advanced_search_form_data
      end

    log_cache_state(cache_state, adv_index_cache_key)
  end

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

  # We need to ensure that the query that populates the advanced search
  # form (which has no search params) facets isn't limited to just the homepage
  # facets (TD-1263). So we essentially replicate core BL's advanced_search action,
  # just with the home facet filters removed. See:
  # https://github.com/projectblacklight/blacklight/blob/release-8.x/app/controllers/concerns/blacklight/catalog.rb#L53-L55
  def advanced_search_form_data
    @advanced_search_form_data ||=
      blacklight_advanced_search_form_search_service.search_results do |builder|
        builder.except(:only_home_facets)
      end
  end

  def log_cache_state(cache_state, cache_key)
    return unless cache_state && cache_key

    case cache_state
    when 'cacheable'
      logger.info "Cache hit: Got Solr response from cache for key: #{cache_key}"
    when 'cache miss'
      logger.info "Cache miss: Generated Solr response for cache key: #{cache_key}"
    end
  end
end
