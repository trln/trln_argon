module TrlnArgon
  module ArgonSearchBuilder
    module QueryEscape

      def escape_query_string(solr_parameters)
        solr_parameters[:q] = RSolr.solr_escape(solr_parameters[:q]) if solr_parameters[:q]
      end
    end
  end
end