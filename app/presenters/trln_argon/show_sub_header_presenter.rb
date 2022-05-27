# frozen_string_literal: true
module TrlnArgon
  class ShowSubHeaderPresenter < Blacklight::ShowPresenter

    private

    def fields
      configuration.show_sub_header_fields
    end

    def field_config(field)
      configuration.show_sub_header_fields.fetch(field) { Blacklight::Configuration::NullField.new(field) }
    end
  end
end