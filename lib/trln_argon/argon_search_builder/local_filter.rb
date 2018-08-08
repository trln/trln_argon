module TrlnArgon
  module ArgonSearchBuilder
    module LocalFilter
      def show_only_local_holdings(solr_parameters)
        solr_parameters[:fq] ||= []
        solr_parameters[:fq] << local_records_query
      end

      def rollup_duplicate_records(solr_parameters)
        solr_parameters[:fq] ||= []
        solr_parameters[:fq] << record_rollup_query
      end

      private

      def local_records_query
        "#{TrlnArgon::Fields::INSTITUTION_FACET}:"\
        "#{TrlnArgon::Engine.configuration.local_institution_code}"
      end

      def record_rollup_query
        "{!collapse field=#{TrlnArgon::Fields::ROLLUP_ID} "\
        'nullPolicy=expand '\
        "max=termfreq(#{TrlnArgon::Fields::INSTITUTION_FACET},"\
        "\"#{TrlnArgon::Engine.configuration.local_institution_code}\")}"
      end
    end
  end
end
