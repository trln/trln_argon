module TrlnArgon
  module ArgonSearchBuilder
    module MinMatch
      def min_match_for_boolean(solr_parameters)
        return unless blacklight_params &&
                      blacklight_params[:q].present? &&
                      blacklight_params[:q].respond_to?(:match) &&
                      blacklight_params[:q].match(/\s(AND|OR|NOT)\s/)
        solr_parameters[:mm] = '1'
      end

      # Adapted from https://github.com/pulibrary/orangelight/blob/master/app/helpers/blacklight_helper.rb
      # Adapted from http://discovery-grindstone.blogspot.com/2014/01/cjk-with-solr-for-libraries-part-12.html
      def min_match_for_cjk(solr_parameters)
        return unless blacklight_params &&
                      blacklight_params[:q].present? &&
                      cjk_unigrams_size(blacklight_params[:q]) > 2
        solr_parameters[:mm] =
          calc_min_match_for_cjk(num_non_cjk_tokens(blacklight_params[:q]))
      end

      private

      def calc_min_match_for_cjk(num_non_cjk_tokens)
        return cjk_min_match_value if num_non_cjk_tokens.zero?
        (cjk_min_match_value[0].to_i + num_non_cjk_tokens).to_s +
          cjk_min_match_value[1, cjk_min_match_value.size]
      end

      def num_non_cjk_tokens(q_param)
        if q_param && q_param.respond_to?(:scan)
          q_param.gsub(/\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}/, '')
                 .scan(/[[:alnum:]]+/).size
        else
          0
        end
      end

      def cjk_unigrams_size(q_param)
        if q_param && q_param.respond_to?(:scan)
          q_param.scan(/\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}/).size
        else
          0
        end
      end

      def cjk_min_match_value
        '3<86%'
      end
    end
  end
end
