module TrlnArgon
  module ViewHelpers
    module HierarchyHelper
      include Blacklight::HierarchyHelper

      def render_qfacet_value(facet_solr_field, item, options = {})
        (link_to_unless(options[:suppress_link],
                        q_value(facet_solr_field, item),
                        q_facet_params(facet_solr_field, item),
                        class: 'facet_select') + ' ' + render_facet_count(item.hits)).html_safe
      end

      def q_value(facet_solr_field, item)
        if facet_solr_field == TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.to_s
          map_argon_facet_codes(item)
        else
          item.value
        end
      end

      def q_facet_params(facet_solr_field, item)
        search_state.add_facet_params(facet_solr_field, item.qvalue).to_h
      end

      def map_argon_facet_codes(item)
        TrlnArgon::LookupManager.instance.map([item.qvalue.split(':').first, 'facet', item.value].join('.'))
      end
    end
  end
end
