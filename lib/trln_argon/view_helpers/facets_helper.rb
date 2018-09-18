module TrlnArgon
  module ViewHelpers
    module FacetsHelper
      def render_home_facets
        render_facet_partials home_facets
      end

      def home_facets
        blacklight_config.home_facet_fields.keys
      end
    end
  end
end
