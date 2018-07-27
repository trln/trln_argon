module TrlnArgon
  module ControllerOverride
    module LocalFilter
      extend ActiveSupport::Concern

      included do
        helper_method :filtered_results_total
      end

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
