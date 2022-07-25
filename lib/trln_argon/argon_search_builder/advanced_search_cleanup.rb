module TrlnArgon
  module ArgonSearchBuilder
    # when an advanced search is issued, the query is likely to contain
    # 'friendly' values for various facets displayed on the home page (e.g.
    # `last_week` for freshly cataloged items)
    module AdvancedSearchCleanup
      def facetize_advanced_search_fields(solr_parameters)
        return unless blacklight_params[:search_field] == 'advanced'

        remove_facet_convenience_values(blacklight_config.home_facet_fields, solr_parameters)
      end

      private

      # advanced search will often add the 'convenience' value (e.g. `last_week`)
      # as the value of a facet, but with a little extra escaping, e.g.
      # `date_cataloged_dt:(\"last_week\")`
      def remove_facet_convenience_values(home_facet_config, solr_parameters)
        solr_parameters[:fq].reject! do |k, _|
          solr_field, solr_value = k.split(':')
          cf = home_facet_config[solr_field]
          cf&.query&.include?(solr_value&.gsub(/[\W:]/, ''))
        end
      end
    end
  end
end
