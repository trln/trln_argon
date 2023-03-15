module TrlnArgon
  module ArgonSearchBuilder
    module ClauseCount
      def clause_count(solr_parameters)
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
        end

        truncate_query(solr_parameters, length)
      end

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
