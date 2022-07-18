module TrlnArgon
  module ViewHelpers
    module AdvancedSearchHelper
      def advanced_search_enabled?
        configuration.advanced_search.enabled
      end

      def advanced_search_page_class
        'advanced-search-form col-sm-12'
      end

      def advanced_search_form_class
        'col-lg-8'
      end

      def advanced_search_help_class
        'col-lg-4'
      end
    end
  end
end
