module TrlnArgon
  module Document
    class CitationComponent < Blacklight::Document::CitationComponent
      def initialize(document:)
        super
        @document = document
      end
    end
  end
end
