module TrlnArgon
  # Multi select facet component using TomSelect
  class MultiSelectFacetComponent < Blacklight::Component
    def initialize(facet_field:, layout: nil)
      super()
      @facet_field = facet_field
      @layout = layout == false ? FacetFieldNoLayoutComponent : Blacklight::FacetFieldComponent
    end

    # @return [Boolean] whether to render the component
    def render?
      presenters.any?
    end

    # @return [Array<Blacklight::FacetFieldPresenter>] array of facet field presenters
    def presenters
      return [] unless @facet_field.paginator

      return to_enum(:presenters) unless block_given?

      @facet_field.paginator.items.each do |item|
        yield @facet_field.facet_field
                          .item_presenter
                          .new(item, @facet_field.facet_field, helpers, @facet_field.key, @facet_field.search_state)
      end
    end

    # @return [Hash] HTML attributes for the select element
    def select_attributes
      {
        class: "#{@facet_field.key}-select",
        name: "f_inclusive[#{@facet_field.key}][]",
        placeholder: I18n.t('facets.advanced_search.placeholder'),
        multiple: true,
        data: {
          controller: 'multi-select',
          multi_select_plugins_value: select_plugins.to_json
        }
      }
    end

    # @return [Hash] HTML attributes for the option elements within the select element
    def option_attributes(presenter:)
      {
        value: presenter.value,
        selected: presenter.selected? ? 'selected' : nil
      }
    end

    # TomSelect functionality can be expanded with plugins. `checkbox_options`
    # allow us to use the existing advanced search facet logic by using checkboxes.
    # More plugins can be found here: https://tom-select.js.org/plugins/
    #
    # @return [Array<String>] array of TomSelect plugins
    def select_plugins
      %w[checkbox_options caret_position input_autogrow clear_button]
    end
  end
end
