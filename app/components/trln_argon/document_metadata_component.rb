module TrlnArgon
  class DocumentMetadataComponent < Blacklight::DocumentMetadataComponent
    def initialize(fields: [], show: false)
      super
      @fields = fields.map(&:itself) if fields.is_a?(Enumerator)
      @show = show
    end

    def render?
      @fields.present?
    end
  end
end
