require 'parsing_nesting/tree'

# This patches BL Advanced Search to rescue from a failed query parse.
# For now, when this happens, skip the parse, log the error, and continue.
# The likely result is No Results Found, which seems better than an error.
module BlacklightAdvancedSearch
  module ParsingNestingParser
    def process_query(_params, config)
      queries = keyword_queries.map do |field, query|
        begin
          query = remove_quotes(query) if unbalanced_quotes?(query)
          query = remove_parentheses(query) if unbalanced_parentheses?(query)
          ParsingNesting::Tree.parse(query, config.advanced_search[:query_parser])
                              .to_query(local_param_hash(field, config))
        rescue Parslet::ParseFailed => e
          Rails.logger.warn { "failed to parse the advanced search query (#{query}): #{e.message}" }
          next
        end
      end
      queries.join(" #{keyword_op} ")
    end

    private

    def unbalanced_quotes?(query)
      query.count('"').odd?
    end

    def remove_quotes(query)
      query.delete('"')
    end

    def unbalanced_parentheses?(query)
      query.count('(') != query.count(')')
    end

    def remove_parentheses(query)
      query.gsub(/[()]/, '')
    end
  end
end
