# frozen_string_literal: true

module TrlnArgon
  class StartOverButtonComponent < Blacklight::StartOverButtonComponent
    def call
      link_to "<i class='fa fa-repeat'></i> Start over".html_safe, start_over_path,
              class: 'catalog_startOverLink btn btn-primary btn-sm',
              id: 'startOverLink'
    end
  end
end
