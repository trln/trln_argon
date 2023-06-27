module TrlnArgon
  module ArgonSearchBuilder
    module ClauseCount
      # rubocop:disable Metrics/CyclomaticComplexity
      def clause_count(solr_parameters)
        # Option to bypass query truncation, esp. while still on Solr 7.
        # Truncation will be necessary for Solr 9+.
        return unless TrlnArgon::Engine.configuration.enable_query_truncation.present?
        return unless query_is_present?(solr_parameters)

        case blacklight_params['search_field']
        when 'all_fields'
          # 10 terms, 1 will be added while truncating
          length = 9
        when 'title'
          # 19 terms + "edismax", "qf", "title_qf", "pf", "title_pf", "pf3", "title_pf3", "pf2", "title_pf2"
          length = 28
        when 'author'
          # 27 terms + "edismax", "qf", "author_qf", "pf", "author_pf", "pf3", "author_pf3", "pf2", "author_pf2"
          length = 36
        when 'subject'
          # 132 + "edismax",  "qf", "subject_qf", "pf", "subject_pf", "pf3", "subject_pf3", "pf2", "subject_pf2"
          length = 141
        when 'isbn_issn'
          # 117 + "edismax", "qf", "isbn_issn_qf", "pf", "pf3", "pf2"
          length = 123
        else
          # 20 fallback for any other search field, e.g., call_number
          # Note that call_number may have its own search builder, see:
          # https://github.com/trln/argon_call_number_search
          length = 19
        end

        truncate_query(solr_parameters, length)
      end
      # rubocop:enable Metrics/CyclomaticComplexity

      private

      def query_is_present?(solr_parameters)
        solr_parameters[:q].present? && blacklight_params[:q].present?
      end

      def query_length(solr_parameters)
        solr_parameters[:q].split(/\b/).select { |x| x.match?(/\w/) }.length
      end

      def truncate_query(solr_parameters, length)
        solr_parameters[:q] = solr_parameters[:q].truncate_words(length + 1, separator: /\W+/, omission: '') unless
           query_length(solr_parameters) <= length
      end
    end
  end
end
