# frozen_string_literal: true

module RenderConstraintsHelper
  #include TrlnArgon::ViewHelpers::RenderConstraintsHelperBehavior

  def custom_facet_value(facet_field, value)
    case facet_field.key
    when TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.to_s
      location_filter_display(h(value))
    when TrlnArgon::Fields::DATE_CATALOGED_FACET.to_s
      date_cataloged_field_value(value)
    else
      h(value)
    end
  end

  private

  def date_cataloged_field_value(value)
    mappings = blacklight_config.home_facet_fields[TrlnArgon::Fields::DATE_CATALOGED_FACET]&.query
    mappings.present? ? mappings.fetch(value, { label: value })[:label] : value
  end
end
