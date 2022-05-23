# frozen_string_literal: true

module TrlnArgon
  class ConstraintComponent < Blacklight::ConstraintComponent
    with_collection_parameter :facet_item_presenter

    def initialize(facet_item_presenter:, classes: 'filter', layout: TrlnArgon::ConstraintLayoutComponent)
      super
      @facet_item_presenter = facet_item_presenter
      @classes = classes
      @layout = layout
    end
  end
end
