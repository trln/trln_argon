module TrlnArgon
  module ArgonSearchBuilder
    module WildcardCharStrip
      def wildcard_char_strip(solr_parameters)
        return unless solr_parameters[:q]
        solr_parameters[:q] = solr_parameters[:q].delete('?')
      end
    end
  end
end
