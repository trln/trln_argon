require 'parsing_nesting/tree'

# This patches BL Advanced Search to rescue from a failed query parse.
# For now, when this happens, skip the parse, log the error, and continue.
# The likely result is No Results Found, which seems better than an error.
module BlacklightAdvancedSearch
  module ParsingNestingParser
    def process_query(_params, config)
      queries = keyword_queries.map do |field, query|
        begin
          ParsingNesting::Tree.parse(query, config.advanced_search[:query_parser])
                              .to_query(local_param_hash(field, config))
        rescue Parslet::ParseFailed => e
          Rails.logger.warn { "failed to parse the advanced search query (#{query}): #{e.message}" }
          next
        end
      end
      queries.join(" #{keyword_op} ")
    end
  end
end
