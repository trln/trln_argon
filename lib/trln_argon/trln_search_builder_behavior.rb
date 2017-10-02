module TrlnArgon
  # Shared SearchBuilder behaviors concerning record rollup,
  # local record filtering, and ISxN match boosting.
  module TrlnSearchBuilderBehavior
    def apply_local_filter(solr_parameters)
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << if blacklight_params[:local_filter].to_s == 'true'
                                local_holdings_query
                              else
                                record_rollup_query
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

    def boost_isxn_matches(solr_parameters)
      solr_parameters[:q] ||= []
      isxn_boosts.each do |boost_type, boost_q|
        if boost_q.present?
          solr_parameters[:q] = solr_parameters[:q].dup << isxn_nested_query(boost_type)
          solr_parameters[boost_type] = boost_q
        end
      end
    end

    private

    def record_rollup_query
      # "{!collapse field=#{TrlnArgon::Fields::ROLLUP_ID} "\
      # "nullPolicy=expand "\
      # "max=termfreq(#{TrlnArgon::Fields::INSTITUTION_FACET},"\
      # "\"#{TrlnArgon::Engine.configuration.preferred_records}\")}"
    end

    def local_holdings_query
      local_values.map do |value|
        "#{TrlnArgon::Fields::INSTITUTION_FACET}:#{value}"
      end.join(' OR ')
    end

    def local_values
      TrlnArgon::Engine.configuration.local_records.split(',').map(&:strip)
    end

    def isxn_nested_query(boost_type)
      " _query_:\"{!edismax qf=$isbn_issn_qf v=$#{boost_type}}\"^2"
    end

    def isxn_boosts
      { isxn_v:    extract_isxn_vals_from_q(blacklight_params[:q]),
        isxn_ns_v: strip_non_isxn_chars(blacklight_params[:q]) }
    end

    def strip_non_isxn_chars(q_blacklight_param)
      return unless q_blacklight_param
      non_isxn_chars_removed = q_blacklight_param.gsub(/[^0-9Xx]/, '')
      extracted_isxns = StdNum::ISBN.extract_multiple_numbers(non_isxn_chars_removed)
      normalize_isxn(extracted_isxns.join)
    end

    def extract_isxn_vals_from_q(q_blacklight_param)
      return unless q_blacklight_param
      extracted_isxns = StdNum::ISBN.extract_multiple_numbers(q_blacklight_param)
      extracted_isxns.map { |isxn_value| normalize_isxn(isxn_value) }.join(' ')
    end

    def normalize_isxn(isxn_value)
      StdNum::ISBN.normalize(isxn_value) || StdNum::ISSN.normalize(isxn_value) || ''
    end
  end
end
