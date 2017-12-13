module TrlnArgon
  module RenderConstraintsHelperBehavior
    ##
    # Render the actual constraints, not including header or footer
    # info.
    #
    # @param [Hash] query parameters
    # @return [String]
    def render_constraints(localized_params = params)
      super + render_constraints_begins_with(localized_params)
    end

    ##
    # Render a single facet's constraint
    #
    # @param [String] facet field
    # @param [Array<String>] selected facet values
    # @param [Hash] query parameters
    # @return [String]
    def render_filter_element(facet, values, _localized_params)
      facet_config = facet_configuration_for_field(facet)

      safe_join(values.map do |val|
        next if val.blank? # skip empty string
        display_value = filter_element_display_value(facet_config, facet, val)
        render_constraint_element(
          facet_field_label(facet_config.key), display_value,
          remove: search_action_path(search_state.remove_facet_params(facet, val)),
          classes: ['filter', 'filter-' + facet.parameterize]
        )
      end, "\n")
    end

    def filter_element_display_value(facet_config, facet, val)
      if facet_config.filter_element_helper
        send(facet_config.filter_element_helper, facet_display_value(facet, val))
      else
        facet_display_value(facet, val)
      end
    end

    ##
    # Render the begins_with constraints
    #
    # @param [Hash] query parameters
    # @return [String]
    def render_constraints_begins_with(localized_params = params)
      return ''.html_safe unless localized_params[:begins_with]
      content = []
      localized_params[:begins_with].each_pair do |begins_with, values|
        content << render_begins_with_element(begins_with, values, localized_params)
      end

      safe_join(content.flatten, "\n")
    end

    ##
    # Render a single begins_with constraint
    #
    # @param [String] begins_with field
    # @param [Array<String>] selected begins_with values
    # @param [Hash] query parameters
    # @return [String]
    def render_begins_with_element(begins_with, values, localized_params)
      facet_config = facet_configuration_for_field(begins_with)

      safe_join(values.map do |val|
        next if val.blank? # skip empty string
        render_constraint_element(
          "#{facet_field_label(facet_config.key)} (#{I18n.t('trln_argon.search_constraints.begins_with')})",
          facet_display_value(begins_with, val),
          remove: search_action_path(remove_begins_with_params(begins_with, val, localized_params)),
          classes: ['filter', "filter-#{begins_with.parameterize}"]
        )
      end, "\n")
    end

    # copies the current params (or whatever is passed in as the 3rd arg)
    # removes the field value from params[:begins_with]
    # removes the field if there are no more values in params[:begins_with][field]
    # removes additional params (page, id, etc..)
    def remove_begins_with_params(field, item, source_params = params) # rubocop:disable Metrics/AbcSize
      field = item.field if item.respond_to? :field

      url_field = facet_configuration_for_field(field).key
      p = reset_search_params(source_params)

      # need to dup the facet values too,
      # if the values aren't dup'd, then the values
      # from the session will get remove in the show view...
      p[:begins_with] = (p[:begins_with] || {}).dup
      p[:begins_with][url_field] = (p[:begins_with][url_field] || []).dup
      p[:begins_with][url_field] = p[:begins_with][url_field] - [facet_value_for_facet_item(item)]
      p[:begins_with].delete(url_field) if p[:begins_with][url_field].size.zero?
      p.delete(:begins_with) if p[:begins_with].empty?
      p
    end
  end
end
