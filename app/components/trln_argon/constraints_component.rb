module TrlnArgon
  class ConstraintsComponent < Blacklight::ConstraintsComponent


    # rubocop:disable Metrics/ParameterLists
    def initialize(search_state:,
                   tag: :div,
                   render_headers: true,
                   id: 'appliedParams', classes: 'clearfix constraints-container',
                   query_constraint_component: TrlnArgon::ConstraintLayoutComponent,
                   query_constraint_component_options: {},
                   facet_constraint_component: TrlnArgon::ConstraintComponent,
                   facet_constraint_component_options: {},
                   start_over_component: TrlnArgon::StartOverButtonComponent)
      @search_state = search_state
      @query_constraint_component = query_constraint_component
      @query_constraint_component_options = query_constraint_component_options
      @facet_constraint_component = facet_constraint_component
      @facet_constraint_component_options = facet_constraint_component_options
      @start_over_component = start_over_component
      @render_headers = render_headers
      @tag = tag
      @id = id
      @classes = classes
    end
  end
end
