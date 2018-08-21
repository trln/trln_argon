# Solr 7.2 BL compatibility hack.
# Forces BL Advanced Search to specify
# local params query type as edismax.
module BlacklightAdvancedSearch
  class QueryParser
    # rubocop:disable ClassAndModuleChildren
    module ParsingNesting::Tree
      class Node
        # rubocop:disable MethodLength
        # rubocop:disable AbcSize
        def build_nested_query(embeddables, solr_params = {}, options = {})
          options = { always_nested: true,
                      force_deftype: 'dismax' }.merge(options)

          # if it's pure negative, we need to transform
          if embeddables.find_all { |n| n.is_a?(ExcludedClause) }.length == embeddables.length
            negated = NotExpression.new(List.new(embeddables.collect(&:operand), options[:force_deftype]))
            solr_params = solr_params.merge(mm: '1')
            return negated.to_query(solr_params)
          else
            collected_embeddables = embeddables.collect(&:to_embed).join(' ')
            inner_query = build_local_params(solr_params, options[:force_deftype]) +
                          TrlnArgon::SolrEscape.escape_escaped_backslash(
                            TrlnArgon::SolrEscape.escape_colon_after_space(
                              collected_embeddables
                            )
                          )
            return ('_query_:"' + bs_escape(inner_query) + '"') if options[:always_nested]
            return inner_query
          end
        end

        def build_local_params(hash = {}, _force_deftype = 'edismax')
          if !hash.empty?
            '{!edismax ' + hash.collect { |k, v| "#{k}=#{v.to_s.include?(' ') ? "'" + v + "'" : v}" }.join(' ') + '}'
          else
            # still have to set edismax
            '{!edismax}'
          end
        end
      end
    end
  end
end
