module TrlnArgon
  module ArgonSearchBuilder
    module DisableBooleanForAllCaps
      # Turn Boolean off by downcasing the query if there
      # are no lowercase letters present, likely indicating
      # a copy/paste all caps query where Boolean query
      # behavior is not expected
      def disable_boolean_for_all_caps(solr_parameters)
        return unless blacklight_params &&
                      blacklight_params[:q].present? &&
                      blacklight_params[:q].respond_to?(:match) &&
                      blacklight_params[:q].match(/\s(AND|OR|NOT)\s/) &&
                      !blacklight_params[:q].match(/[a-z]+/)
        solr_parameters[:q] = solr_parameters[:q].downcase
      end
    end
  end
end
