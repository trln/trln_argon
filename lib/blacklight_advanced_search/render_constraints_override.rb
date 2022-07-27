module BlacklightAdvancedSearch
  module RenderConstraintsOverride
    # the default implementation from blacklight_advanced_search
    # plugin will effectively duplicate constraints in search header
    # so we need to override only some methods

    # copied directly from upstream, deals with TD-1219
    # the other `render_constraints_` methods will be handled
    # by the base implementation in BL rather than by the 
    # implementation in the adv_search plugin 
    def render_constraints_query(my_params = params)
      if (advanced_query.nil? || advanced_query.keyword_queries.empty?)
        return super(my_params)
      else
        content = []
        advanced_query.keyword_queries.each_pair do |field, query|
          label = blacklight_config.search_fields[field][:label]
          content << render_constraint_element(
            label, query,
            :remove =>
              search_action_path(remove_advanced_keyword_query(field, my_params).except(:controller, :action))
          )
        end
        if (advanced_query.keyword_op == "OR" &&
            advanced_query.keyword_queries.length > 1)
          content.unshift content_tag(:span, "Any of:", class: 'operator')
          content_tag :span, class: "inclusive_or appliedFilter well" do
            safe_join(content.flatten, "\n")
          end
        else
          safe_join(content.flatten, "\n")
        end
      end
    end

    def remove_advanced_keyword_query(field, my_params = params)
      my_params = Blacklight::SearchState.new(my_params, blacklight_config).to_h
      my_params.delete(field)
      my_params
    end

  end
end
