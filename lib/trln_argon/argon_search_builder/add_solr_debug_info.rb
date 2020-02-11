module TrlnArgon
  module ArgonSearchBuilder
    module AddSolrDebugInfo
      def add_solr_debug(solr_parameters)
        return unless blacklight_params[:debug] == 'true'
        solr_parameters[:fl] = '*,score'
      end
    end
  end
end
