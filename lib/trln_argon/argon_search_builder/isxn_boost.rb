module TrlnArgon
  module ArgonSearchBuilder
    module IsxnBoost
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

      def isxn_nested_query(boost_type)
        " _query_:\"{!edismax qf=$isbn_issn_qf v=$#{boost_type}}\"^2"
      end

      def isxn_boosts
        { isxn_v:    extract_isxn_vals_from_q(blacklight_params[:q]),
          isxn_ns_v: strip_non_isxn_chars(blacklight_params[:q]) }
      end

      def strip_non_isxn_chars(q_blacklight_param)
        return unless q_blacklight_param
        non_isxn_chars_removed = q_blacklight_param.to_s.gsub(/[^0-9Xx]/, '')
        extracted_isxns = StdNum::ISBN.extract_multiple_numbers(non_isxn_chars_removed)
        normalize_isxn(extracted_isxns.join)
      end

      def extract_isxn_vals_from_q(q_blacklight_param)
        return unless q_blacklight_param
        extracted_isxns = StdNum::ISBN.extract_multiple_numbers(q_blacklight_param.to_s)
        extracted_isxns.map { |isxn_value| normalize_isxn(isxn_value) }.join(' ')
      end

      def normalize_isxn(isxn_value)
        StdNum::ISBN.normalize(isxn_value) || StdNum::ISSN.normalize(isxn_value) || ''
      end
    end
  end
end
