module TrlnArgon
  class AdvancedSearchRangeLimitComponent < Blacklight::Component
    include ViewHelpers

    def initialize(facet_field:, **args)
      super
      @facet_field = facet_field
    end

    # update range inputs to only allow numbers
    def render_range_input(solr_field, type, input_label = nil, maxlength = 4)
      type = type.to_s

      if params['range'] && params['range'][solr_field] && params['range'][solr_field][type]
        default = params['range'][solr_field][type]
      end

      html = label_tag("range[#{solr_field}][#{type}]", input_label, class: 'visually-hidden') if input_label.present?
      html ||= ''.html_safe
      html + text_field_tag("range[#{solr_field}][#{type}]",
                            default,
                            maxlength: maxlength,
                            class: "form-control range_#{type}",
                            pattern: '[0-9]+',
                            oninvalid: "setCustomValidity('Publication Year should be a number')",
                            oninput: "setCustomValidity('')")
    end
  end
end
