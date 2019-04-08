# frozen_string_literal: true

module TrlnArgon
  module ArgonSearchBuilder
    module SubjectsBoost
      def subjects_boost(solr_parameters)
        return unless includes_subject_search?

        solr_parameters[:bq] ||= []
        solr_parameters[:bq] << subjects_english_boost_query
        solr_parameters[:bq] << subjects_title_boost_query
        solr_parameters[:bq] << subjects_books_boost_query

        solr_parameters[:bf] ||= []
        solr_parameters[:bf] << subjects_recent_boost_function
      end

      private

      def subjects_recent_boost_function
        current_year = Date.today.year
        current_year_plus_two = current_year + 2
        current_year_minus_ten = current_year - 10
        'linear(map(' \
        "#{TrlnArgon::Fields::PUBLICATION_YEAR_SORT},#{current_year_plus_two},10000," \
        "#{current_year_minus_ten},abs(#{TrlnArgon::Fields::PUBLICATION_YEAR_SORT})),11,0)^50"
      end

      def subjects_books_boost_query
        "#{TrlnArgon::Fields::RESOURCE_TYPE_FACET}:Book^100"
      end

      def subjects_english_boost_query
        "#{TrlnArgon::Fields::LANGUAGE_FACET}:English^10000"
      end

      def subjects_title_boost_query
        if blacklight_params.key?(:q) &&
           blacklight_params[:q].present?
          standard_search_title_boost
        elsif blacklight_params.key?('subject') &&
              blacklight_params['subject'].present?
          advanced_search_title_boost
        end
      end

      def standard_search_title_boost
        "#{TrlnArgon::Fields::TITLE_MAIN_INDEXED}:"\
        "(#{RSolr.solr_escape(blacklight_params[:q])})^500"
      end

      def advanced_search_title_boost
        "#{TrlnArgon::Fields::TITLE_MAIN_INDEXED}:"\
        "(#{RSolr.solr_escape(blacklight_params['subject'])})^500"
      end

      def includes_subject_search?
        blacklight_params.key?('search_field') &&
          ((blacklight_params['search_field'] == 'subject' ||
          blacklight_params['search_field'] == 'genre_headings') ||
          (blacklight_params['search_field'] == 'advanced' &&
          blacklight_params.fetch('subject', nil).present?))
      end
    end
  end
end
