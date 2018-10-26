module TrlnArgon
  module ArgonSearchBuilder
    module HomeFacets
      def only_home_facets(solr_parameters)
        return if search_parameters?
        solr_parameters['facet.field'] = blacklight_config.home_facet_fields.keys # home_facets
        solr_parameters['facet.pivot'] = []
      end

      def search_parameters?
        blacklight_params[:q].present? ||
          blacklight_params[:f].present? ||
          blacklight_params[:search_field].present?
      end
    end
  end
end
