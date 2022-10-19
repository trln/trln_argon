module TrlnArgon
  class AdvancedSearchFormComponent < Blacklight::AdvancedSearchFormComponent
    include RangeLimitHelper
    include ViewHelpers

    # update range inputs to only allow numbers
    def render_range_input(solr_field, type, input_label = nil, maxlength = 4)
      type = type.to_s

      if params['range'] && params['range'][solr_field] && params['range'][solr_field][type]
        default = params['range'][solr_field][type]
      end

      html = label_tag("range[#{solr_field}][#{type}]", input_label, class: 'sr-only') if input_label.present?
      html ||= ''.html_safe
      html + text_field_tag("range[#{solr_field}][#{type}]",
                            default,
                            maxlength: maxlength,
                            class: "form-control range_#{type}",
                            pattern: '[0-9]+',
                            oninvalid: "setCustomValidity('Publication Year should be a number')",
                            oninput: "setCustomValidity('')")
    end

    private

    # Override of https://github.com/projectblacklight/blacklight/blob/ce114b6c3709e09efcd2fa91429b84dd6f2ca08b/app/components/blacklight/advanced_search_form_component.rb#L39
    # Adjusts classes for labels and inputs
    def initialize_search_field_controls
      search_fields.values.each.with_index do |field, i|
        search_field_control do
          fields_for('clause[]', i, include_id: false) do |f|
            content_tag(:div, class: 'form-group advanced-search-field row mb-3') do
              f.label(:query, field.display_label('search'), class: 'col-12 col-md-3 col-form-label text-md-right') +
                content_tag(:div, class: 'col-12 col-md-9') do
                  f.hidden_field(:field, value: field.key) +
                    f.text_field(:query, value: query_for_search_clause(field.key), class: 'form-control')
                end
            end
          end
        end
      end
    end
  end
end
