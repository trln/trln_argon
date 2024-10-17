module TrlnArgon
  class DocumentComponent < Blacklight::DocumentComponent
    def before_render
      set_slot(
        :metadata,
        nil,
        fields: @presenter&.field_presenters,
        component: TrlnArgon::DocumentHeaderMetadataComponent
      )
      super
    end
  end
end
