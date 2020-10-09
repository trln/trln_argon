# frozen_string_literal: true
module TrlnArgon
  class ShowAuthorsPresenter < Blacklight::ShowPresenter

    private

    def fields
      configuration.show_authors_fields
    end

    def field_config(field)
      configuration.show_authors_fields.fetch(field) { Blacklight::Configuration::NullField.new(field) }
    end
  end
end