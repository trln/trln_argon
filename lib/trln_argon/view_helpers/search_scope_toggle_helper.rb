module TrlnArgon
  module ViewHelpers
    module SearchScopeToggleHelper
      def query_state_from_search_state(search_state)
        return {} unless search_state.respond_to?(:params)
        query_state = search_state.params.to_h.deep_dup
        query_state.delete('controller')
        query_state.delete('action')
        query_state
      end

      def local_search_button_class
        'btn-primary active'
      end

      def trln_search_button_class
        'btn-outline-secondary'
      end

      def local_search_button_label_class
        'active'
      end

      def trln_search_button_label_class
        ''
      end

      def no_results_escape_href_url
        case filtered_results_total
        when 0
          search_catalog_path
        else
          search_trln_path(query_state_from_search_state(search_state))
        end
      end
    end
  end
end
