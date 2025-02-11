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
        class: "#{@facet_field.key}-select multi-select",
        name: "f_inclusive[#{@facet_field.key}][]",
        placeholder: I18n.t('facets.advanced_search.placeholder'),
        multiple: true
      }
    end

    # @return [Hash] HTML attributes for the option elements within the select element
    def option_attributes(presenter:)
      {
        value: presenter.value,
        selected: presenter.selected? ? 'selected' : nil
      }
    end
  end
end
