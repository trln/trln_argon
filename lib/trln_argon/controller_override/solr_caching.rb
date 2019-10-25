# implements caching for certain expensive queries
# where liveness of results is not a top concern.
module SolrCaching
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def cached_catalog_index
    if cache_solr_response?
      cache_key = "#{params.fetch('controller', '')}/"\
                  "#{params.fetch('action', '')}/"\
                  'facet_query'
    end

    (@response, @document_list) =
      if cache_key
        logger.info('index page solr response cache hit')
        Rails.cache.fetch(cache_key.to_s, expires_in: solr_cache_exp_time) do
          search_results(params)
        end
      else
        search_results(params)
      end

    respond_to do |format|
      format.html { store_preferred_view }
      format.rss  { render layout: false }
      format.atom { render layout: false }
      format.json do
        @presenter = Blacklight::JsonPresenter.new(@response,
                                                   @document_list,
                                                   facets_from_request,
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

    if cache_solr_response?
      cache_key = "#{params.fetch('controller', '')}/"\
                  "#{params.fetch('action', '')}/"\
                  'advanced_solr_query'
    end

    @response =
      if cache_key
        logger.info('advanced search page solr response cache hit')
        Rails.cache.fetch(cache_key.to_s, expires_in: solr_cache_exp_time) do
          get_advanced_search_facets
        end
      else
        get_advanced_search_facets
      end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def solr_cache_exp_time
    num_string, time_unit = TrlnArgon::Engine.configuration.solr_cache_exp_time.split('.')
    num_string.to_i.send(time_unit)
  end

  def cache_solr_response?
    (params.keys - %w[controller action]).empty? &&
      !TrlnArgon::Engine.configuration.solr_cache_exp_time.blank?
  end
end
