# frozen_string_literal: true

module TrlnArgon
  module Search
    class SidebarComponent < Blacklight::Search::SidebarComponent
      def initialize(blacklight_config:, response:, view_config:)
        @blacklight_config = blacklight_config
        @response = response
        @group_component_class = view_config.facet_group_component || Blacklight::Response::FacetGroupComponent
      end

      attr_reader :group_component_class, :response

      delegate :facet_group_names, :facet_fields_in_group, to: :@blacklight_config
    end
  end
end
