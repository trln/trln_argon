module TrlnArgon
  module ArgonSearchBuilder
    module CountOnly
      def remove_params_for_count_only_query(solr_parameters)
        solr_parameters.delete('stats')
        solr_parameters.delete('stats.field')
        solr_parameters.delete('expand')
        solr_parameters.delete('expand.rows')
        solr_parameters.delete('expand.q')
      end
    end
  end
end
