module TrlnArgon
  class AdvancedSearchFacetFieldComponent < Blacklight::Component
    include TrlnArgon::ViewHelpers::TrlnArgonHelper
    attr_reader :facet_field, :display_facet

    def initialize(facet_field:, **args)
      super
      @facet_field = facet_field
      @display_facet = facet_field&.display_facet
      logger.info("arguments to #{facet_field.key}: #{args}")
    end

    def field_param
      "f_inclusive[#{facet_field.key}][]"
    end

    def display_value(facet_item)
      "#{facet_value_label(facet_item)}&nbsp;&nbsp;(#{number_with_delimiter facet_item.hits})".html_safe
    end
    
    def selected?(item)
      ' selected="selected"' if params[:f_inclusive]&.fetch(facet_field.key, [])&.include?(item.value)
    end

    def render?
      !!display_facet&.items
    end

    def facet_value_label(facet_item)
      if display_facet.name == TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.to_s
        location_filter_display(facet_item.label)
      else
        facet_item.label
      end
    end
  end
end
