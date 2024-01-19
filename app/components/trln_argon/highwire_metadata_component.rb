module TrlnArgon
  class HighwireMetadataComponent < Blacklight::Component
    def initialize(document)
      super
      @document = document
    end

    def render?
      @document.present?
    end
  end
end
