module TrlnArgon
  class AdvancedSearchFormComponent < Blacklight::AdvancedSearchFormComponent
    include RangeLimitHelper
    include ViewHelpers

    private

    # Override of https://github.com/projectblacklight/blacklight/blob/ce114b6c3709e09efcd2fa91429b84dd6f2ca08b/app/components/blacklight/advanced_search_form_component.rb#L39
    # Adjusts classes for labels and inputs
    def initialize_search_field_controls
      search_fields.values.each.with_index do |field, i|
        with_search_field_control do
          fields_for('clause[]', i, include_id: false) do |f|
            content_tag(:div, class: 'form-group advanced-search-field row mb-3') do
              f.label(:query, field.display_label('search'), class: 'col-12 col-md-3 col-form-label') +
                content_tag(:div, class: 'col-12 col-md-9') do
                  f.hidden_field(:field, value: field.key) +
                    f.text_field(:query, value: query_for_search_clause(field.key), class: 'form-control tt-input',
                                 autocomplete: :off,
                                 data: { adv_search_field: field.key,
                                         autocomplete_enabled: blacklight_config[:autocomplete_enabled],
                                         autocomplete_path: blacklight_config[:autocomplete_path] })
                end
            end
          end
        end
      end
    end
  end
end
