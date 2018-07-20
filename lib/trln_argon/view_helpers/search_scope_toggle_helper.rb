module TrlnArgon
  module ViewHelpers
    module SearchScopeToggleHelper
      def query_state_from_search_state(search_state)
        query_state = search_state.to_h.dup
        query_state.delete('controller')
        query_state.delete('action')
        query_state
      end

      def local_search_button_class
        return 'btn-primary active' if local_filter_applied?
        'btn-default'
      end

      def trln_search_button_class
        return 'btn-default' if local_filter_applied?
        'btn-primary active'
      end

      def local_search_button_label_class
        return 'active' if local_filter_applied?
        ''
      end

      def trln_search_button_label_class
        return '' if local_filter_applied?
        'active'
      end

      def no_results_escape_href_url
        return search_trln_path unless local_filter_applied?
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
