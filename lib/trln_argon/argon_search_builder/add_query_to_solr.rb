module TrlnArgon
  module ArgonSearchBuilder
    module AddQueryToSolr
      ##
      # NOTE: This is an override of the Blacklight SearchBuilder
      #       method of the same name to address the Solr 7
      #       local params compatibility issue.
      #
      #       Applying approach proposed here:
      #         https://github.com/projectblacklight/blacklight/pull/1839/files
      #
      # Take the user-entered query, and put it in the solr params,
      # including config's "search field" params for current search field.
      # also include setting spellcheck.q.
      def add_query_to_solr(solr_parameters)
        ###
        # Merge in search field configured values, if present, over-writing general
        # defaults
        ###
        # legacy behavior of user param :qt is passed through, but over-ridden
        # by actual search field config if present. We might want to remove
        # this legacy behavior at some point. It does not seem to be currently
        # rspec'd.
        solr_parameters[:qt] = blacklight_params[:qt] if blacklight_params[:qt]

        if search_field
          solr_parameters[:qt] = search_field.qt
          solr_parameters.merge!(search_field.solr_parameters) if search_field.solr_parameters
        end

        ##
        # Create Solr 'q' including the user-entered q, prefixed by any
        # solr LocalParams in config, using solr LocalParams syntax.
        # http://wiki.apache.org/solr/LocalParams
        ##
        if search_field && (search_field.solr_local_parameters.present? || search_field.def_type.present?)
          solr_q_with_local_params(solr_parameters)
          ##
          # Set Solr spellcheck.q to be original user-entered query, without
          # our local params, otherwise it'll try and spellcheck the local
          # params!
          solr_parameters["spellcheck.q"] ||= blacklight_params[:q]
        elsif blacklight_params[:q].is_a? Hash
          q = blacklight_params[:q]
          solr_parameters[:q] = if q.values.any?(&:blank?)
                                  # if any field parameters are empty, exclude _all_ results
                                  "{!lucene}NOT *:*"
                                else
                                  "{!lucene}" + q.map do |field, values|
                                    "#{field}:(#{Array(values).map { |x| solr_param_quote(x) }.join(' OR ')})"
                                  end.join(" AND ")
                                end

          solr_parameters[:defType] = 'lucene'
          solr_parameters[:spellcheck] = 'false'
        elsif blacklight_params[:q]
          solr_parameters[:q] = blacklight_params[:q]
        end
      end

      def solr_q_with_local_params(solr_parameters)
        q_parser = if search_field.def_type.present?
                     "#{search_field.def_type} "
                   elsif solr_parameters[:defType]
                     "#{solr_parameters[:defType]} "
                   else
                     ''
                   end
        solr_parameters[:defType] = 'lucene' # to enable parsing of local params
        local_params = if search_field.solr_local_parameters.present?
                         search_field.solr_local_parameters.map do |key, val|
                           key.to_s + "=" + solr_param_quote(val, quote: "'")
                         end.join(" ")
                       else
                         ''
                       end
        solr_parameters[:q] = "{!#{q_parser}#{local_params}}#{blacklight_params[:q]}"
      end
    end
  end
end
