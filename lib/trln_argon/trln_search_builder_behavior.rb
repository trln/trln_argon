module TrlnArgon
  module TrlnSearchBuilderBehavior

    def rollup_duplicate_records(solr_parameters)
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << record_rollup_query
    end

    private

    def record_rollup_query
      "{!collapse field=#{Trln::Catalog::Engine.configuration.rollup_field} "\
      "nullPolicy=expand "\
      "max=termfreq(#{Trln::Catalog::Engine.configuration.preferred_record_field},"\
      "\"#{Trln::Catalog::Engine.configuration.preferred_record_value}\")}"
    end

  end
end
