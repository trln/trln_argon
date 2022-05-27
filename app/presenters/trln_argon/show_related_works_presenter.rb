# frozen_string_literal: true
module TrlnArgon
  class ShowRelatedWorksPresenter < Blacklight::ShowPresenter

    private

    def fields
      configuration.show_related_works_fields
    end

    def field_config(field)
      configuration.show_related_works_fields.fetch(field) { Blacklight::Configuration::NullField.new(field) }
    end
  end
end