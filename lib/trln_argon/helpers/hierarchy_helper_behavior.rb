module TrlnArgon
  module HierarchyHelperBehavior
    def render_qfacet_value(facet_solr_field, item, options = {})
      if facet_solr_field == TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.to_s
        (link_to_unless(options[:suppress_link],
                        map_argon_facet_codes(item),
                        search_state.add_facet_params(facet_solr_field, item.qvalue),
                        class: 'facet_select') + ' ' + render_facet_count(item.hits)).html_safe
      else
        super
      end
    end

    def map_argon_facet_codes(item)
      TrlnArgon::LookupManager.instance.map([item.qvalue.split(':').first, 'facet', item.value].join('.'))
    end
  end
end
