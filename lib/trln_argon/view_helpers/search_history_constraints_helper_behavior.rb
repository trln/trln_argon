module TrlnArgon
  module ViewHelpers
    # Override default BL SearchHistoryConstraintsHelperBehavior
    module SearchHistoryConstraintsHelperBehavior
      include Blacklight::SearchHistoryConstraintsHelperBehavior

      def render_search_to_s(params)
        super + render_search_to_s_begins_with_filters(params)
      end

      # Render the begins with facet constraints
      def render_search_to_s_begins_with_filters(params)
        return ''.html_safe unless params[:begins_with]

        safe_join(params[:begins_with].collect do |facet_field, value_list|
          render_search_to_s_element("#{I18n.t('trln_argon.search_constraints.begins_with')} "\
                                     "#{facet_field_label(facet_field)}",
                                     safe_join(value_list.collect do |value|
                                       render_filter_value(value, facet_field)
                                     end, content_tag(:span, " #{t('blacklight.and')} ", class: 'filterSeparator')))
        end, " \n ")
      end
    end
  end
end
