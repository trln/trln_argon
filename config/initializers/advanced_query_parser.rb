require 'parsing_nesting/tree'

# This patches BL Advanced Search to rescue from a failed query parse.
# For now, when this happens, skip the parse, log the error, and continue.
# The likely result is No Results Found, which seems better than an error.
# Here is the file v8.0.0.alpha2: https://github.com/projectblacklight/blacklight_advanced_search/blob/v8.0.0.alpha2/lib/blacklight_advanced_search/advanced_query_parser.rb
module BlacklightAdvancedSearch
  class QueryParser
    def process_query(config)
      queries = keyword_queries.map do |clause|
        field = clause[:field]
        query = clause[:query]
        begin
          query = remove_quotes(query) if unbalanced_quotes?(query)
          query = remove_parentheses(query) if unbalanced_parentheses?(query)
          query = truncate_query(query, 7) if query_length(query) > 7
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

    def query_length(query)
      query.split(/\b/).select { |x| x.match?(/\w/) }.length
    end

    def truncate_query(query, length)
      query.truncate_words(length, separator: /\W+/, omission: '')
    end
  end
end
