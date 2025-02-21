module TrlnArgon
  # customization of document component for the show page
  # subclass used for index page overwrites the `metadata` slot
  # with the same content used here for the sub header.
  class DocumentShowComponent < Blacklight::DocumentComponent
    # easiest way to use this is to call
    # <%= render with_sub_header %>
    renders_one :sub_header, (lambda do
      generate_sub_header
    end)

    # returns a component configured for the
    # you will still need to call `#render`
    def generate_sub_header
      # to customize the fields shown in the sub header, set
      # blacklight_config.show_sub_header_fields in controller override
      fields = helpers.show_sub_header_presenter(@document).field_presenters
      TrlnArgon::DocumentHeaderMetadataComponent.new(fields: fields)
    end
  end
end
