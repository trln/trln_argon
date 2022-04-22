module TrlnArgon
  module Response
    # Render spellcheck results for a search query
    class SpellcheckComponent < Blacklight::Response::SpellcheckComponent

    private

      def options_from_response(response)
        if response&.spelling&.collation
          response.spelling.collation
        elsif response&.spelling&.words
          response.spelling.words
        end
      end
    end
  end
end
