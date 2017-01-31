module TrlnArgon
  module TrlnSearchBuilderBehavior

    def apply_local_filter(solr_parameters)
      solr_parameters[:fq] ||= []
      if blacklight_params["local_filter"] == 'true'
        solr_parameters[:fq] << local_holdings_query
      else
        solr_parameters[:fq] << record_rollup_query
      end
    end

    def show_only_local_holdings(solr_parameters)
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << local_holdings_query
    end

    def rollup_duplicate_records(solr_parameters)
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << record_rollup_query
    end

    private

    def record_rollup_query
      # TODO: Placeholder for query that will rollup duplicate records:
      #
      # "{!collapse field=#{TrlnArgon::Engine.configuration.rollup_field} "\
      # "nullPolicy=expand "\
      # "max=termfreq(#{TrlnArgon::Engine.configuration.preferred_record_field},"\
      # "\"#{TrlnArgon::Engine.configuration.preferred_record_value}\")}"
    end

    def local_holdings_query
      "language_facet:English" # Arbitrary filter query to test local filter

      # TODO: Placeholder for query that will limit results to local holdings:
      #
      # "#{TrlnArgon::Engine.configuration.local_records_field}:"\
      # "#{TrlnArgon::Engine.configuration.local_records_values.join(" OR ")}"
    end

  end
end
