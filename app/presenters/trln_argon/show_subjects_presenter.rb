# frozen_string_literal: true
module TrlnArgon
  class ShowSubjectsPresenter < Blacklight::ShowPresenter

    private

    def fields
      configuration.show_subjects_fields
    end

    def field_config(field)
      configuration.show_subjects_fields.fetch(field) { Blacklight::Configuration::NullField.new(field) }
    end
  end
end