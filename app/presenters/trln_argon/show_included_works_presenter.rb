# frozen_string_literal: true
module TrlnArgon
  class ShowIncludedWorksPresenter < Blacklight::ShowPresenter

    private

    def fields
      configuration.show_included_works_fields
    end

    def field_config(field)
      configuration.show_included_works_fields.fetch(field) { Blacklight::Configuration::NullField.new(field) }
    end
  end
end