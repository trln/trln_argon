# frozen_string_literal: true

module TrlnArgon
  class StartOverButtonComponent < Blacklight::StartOverButtonComponent
    def initialize(classes:, id: 'startOverLink')
      super
      @classes = classes
      @id = id
    end

    def call
      link_to "<i class='fa fa-repeat'></i> Start over".html_safe, start_over_path,
              class: @classes,
              id: @id
    end
  end
end
