module TrlnArgon
  module ControllerOverride
    module LocalFilter
      extend ActiveSupport::Concern

      included do
        helper_method :filtered_results_total
      end

      # controller action that returns a Solr query response
      # with no documents listed. Primarily used to fetch counts
      # client side for the TRLN/local toggle.
      def count_only
        builder = search_builder.with(params)
        builder.rows = '0'

        builder.processor_chain.delete(:add_facetting_to_solr)
        builder.processor_chain.delete(:only_home_facets)
        builder.processor_chain.delete(:add_facet_paging_to_solr)
        builder.processor_chain.delete(:add_sorting_to_solr)
        builder.processor_chain.append(:remove_params_for_count_only_query)

        response = repository.search(builder)
        render json: response
      end

      # helper method that fetches local or trln results server side
      # for use on the no results page.
      # TODO: May be worth removing this and relying on a client side
      # request like the one above.
      def filtered_results_total
        @filtered_results_total ||=
          filtered_results_query_response['response']['numFound']
      end

      private

      def filtered_results_query_response
        repository.search(local_filter_search_builder
          .append(*additional_processor_chain_methods)
          .with(search_state.to_h))
      end

      # This is needed so that controllers that inherit from CatalogController
      # Will have any additional processor chain methods applied to the
      # query that fetches the local filter count
      def additional_processor_chain_methods
        search_builder.processor_chain -
          local_filter_search_builder.processor_chain -
          excluded_processor_chain_methods
      end

      def excluded_processor_chain_methods
        %i[show_only_local_holdings rollup_duplicate_records]
      end

      def local_filter_search_builder
        RollupOnlySearchBuilder.new(CatalogController)
      end
    end
  end
end
