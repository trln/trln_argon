module TrlnArgon
  module ArgonSearchBuilder
    module LocalFilter
      def apply_local_filter(solr_parameters)
        solr_parameters[:fq] ||= []
        solr_parameters[:fq] << if blacklight_params[:local_filter].to_s == 'true'
                                  local_records_query
                                else
                                  record_rollup_query
                                end
      end

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
        local_values.map do |value|
          "#{TrlnArgon::Fields::INSTITUTION_FACET}:#{value}"
        end.join(' OR ')
      end

      def local_values
        TrlnArgon::Engine.configuration.local_records.split(',').map(&:strip)
      end

      def record_rollup_query
        "{!collapse field=#{TrlnArgon::Fields::ROLLUP_ID} "\
        'nullPolicy=expand '\
        "max=termfreq(#{TrlnArgon::Fields::INSTITUTION_FACET},"\
        "\"#{TrlnArgon::Engine.configuration.preferred_records}\")}"
      end
    end
  end
end
