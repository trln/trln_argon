# frozen_string_literal: true

# TRLN extension using core BL component; see:
# https://github.com/projectblacklight/blacklight/blob/blacklight_8/app/components/blacklight/facet_field_checkboxes_component.rb
module TrlnArgon
  class AccessTypeCheckboxesComponent < Blacklight::FacetFieldCheckboxesComponent
    def render?
      presenters.any? { |presenter| presenter.label == 'Online' }
    end
  end
end
