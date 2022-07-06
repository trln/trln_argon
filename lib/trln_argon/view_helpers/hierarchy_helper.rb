module TrlnArgon
  module ViewHelpers
    module HierarchyHelper
      include Blacklight::HierarchyHelper
      # NOTE: This helper overrides methods that are part of the
      #       Blacklight hierarchy gem. I've noted points of change
      #       inline. Basically, this adds functionality to map location codes
      #       to their display values. It also adds the ability set a sort option
      #       with the hierarchical facet config. This follows the Blacklight
      #       pattern of sort: "index"|"count" -- with index (lexical) being default.
      #       The location facet gets special handling in the case of index sort -- the
      #       codes will be mapped to display values so the display values will sort instead
      #       of the codes stored in Solr.
      #
      #       If you want to change the sort order of the location facet from count to
      #       index in your local application you would add the following to your application's
      #       catalog controller:
      #
      #       before_action :modify_argon_field_defaults
      #
      #       def modify_argon_field_defaults
      #         if blacklight_config.facet_fields.key?(TrlnArgon::Fields::LOCATION_HIERARCHY_FACET)
      #           blacklight_config.facet_fields[TrlnArgon::Fields::LOCATION_HIERARCHY_FACET].sort = 'index'
      #         end
      #       end

      # @param [Blacklight::Configuration::FacetField] as defined in controller
      #        with config.add_facet_field
      #        (and with :partial => 'blacklight/hierarchy/facet_hierarchy')
      # @return [String] html for the facet tree
      def render_hierarchy(bl_facet_field, delim = '_')
        Deprecation.silence(Blacklight::HierarchyHelper) do
          field_name = bl_facet_field.field

          # NOTE CHANGE: Fetch the sort setting from the facet field config.
          sort = bl_facet_field.sort || 'index'

          prefix = field_name.gsub("#{delim}#{field_name.split(/#{delim}/).last}", '')
          facet_tree_for_prefix = facet_tree(prefix)
          tree = facet_tree_for_prefix ? facet_tree_for_prefix[field_name] : nil

          return '' unless tree

          # NOTE CHANGE: Apply the configured sort option to the first node values.
          tree = hierarchy_node_sort(tree, sort, field_name)

          # NOTE CHANGE: Do not sort keys to preserve current sort.
          tree.keys.collect do |key|
            render_facet_hierarchy_item(field_name, tree[key], key, sort)
          end.join("\n").html_safe
        end
      end

      def render_facet_hierarchy_item(field_name, data, key, sort)
        item = data[:_]
        subset = data.select { |k, _v| k.is_a?(String) }

        li_class = subset.empty? ? 'h-leaf' : 'h-node'
        ul = ''
        li = if item.nil?
               key
             elsif facet_in_params?(field_name, item.qvalue)
               render_selected_qfacet_value(field_name, item)
             else
               render_qfacet_value(field_name, item)
             end
        # NOTE CHANGE: adding facet_count to end of li content
        li += render_facet_count(item.hits).html_safe

        unless subset.empty?
          # NOTE CHANGE: Apply the configured sort option to the current node.
          subset = hierarchy_node_sort(subset, sort, field_name)
          subul = subset.keys.collect do |subkey|
            render_facet_hierarchy_item(field_name, subset[subkey], subkey, sort)
          end.join('')
          # NOTE CHANGE: role="group" for accessibility
          ul = %(<ul role="group">#{subul}</ul>).html_safe
        end

        # NOTE CHANGE: role="treeitem" for accessibility
        %(<li role="treeitem" class="#{li_class}">#{li.html_safe}#{ul.html_safe}</li>).html_safe
      end

      def render_selected_qfacet_value(facet_solr_field, item)
        # NOTE CHANGE: rendering remove link inside of content tag, using font-awesome instead of glyphicon
        remove_href = search_action_path(search_state.remove_facet_params(facet_solr_field, item.qvalue))
        content_tag(:span, class: 'selected') do
          concat render_qfacet_value(facet_solr_field, item, suppress_link: true)
          concat ' '
          concat link_to(content_tag(:i, '', class: 'fa fa-times') +
                  content_tag(:span, '[remove]', class: 'sr-only'),
                         remove_href,
                         class: 'remove')
        end
      end

      def hierarchy_node_sort(node, sort, field_name)
        if sort == 'count'
          node.sort_by { |_k, v| v[:_].hits }.reverse.to_h
        elsif field_name == TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.to_s
          node.sort_by { |_k, v| map_argon_facet_codes(v[:_]) }.to_h
        else
          node.sort.to_h
        end
      end

      def render_qfacet_value(facet_solr_field, item, options = {})
        link_to_unless(options[:suppress_link],
                       q_value(facet_solr_field, item),
                       q_facet_params(facet_solr_field, item),
                       # NOTE CHANGE: removed 'render_facet_count(item.hits)'
                       # class: 'facet_select') + ' ' + render_facet_count(item.hits)).html_safe
                       class: 'facet_select').html_safe
      end

      def q_value(facet_solr_field, item)
        if facet_solr_field == TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.to_s
          map_argon_facet_codes(item)
        else
          item.value
        end
      end

      def q_facet_params(facet_solr_field, item)
        # search_state.add_facet_params(facet_solr_field, item.qvalue).to_h
        search_state.filter(facet_solr_field).add(item.qvalue).to_h
      end

      def map_argon_facet_codes(item)
        TrlnArgon::LookupManager.instance.map([item.qvalue.split(':').first, 'facet', item.value].join('.'))
      end
    end
  end
end
