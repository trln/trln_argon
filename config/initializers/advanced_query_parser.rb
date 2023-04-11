require 'parsing_nesting/tree'

# This patches BL Advanced Search to rescue from a failed query parse.
# For now, when this happens, skip the parse, log the error, and continue.
# The likely result is No Results Found, which seems better than an error.
# Here is the file v8.0.0.alpha2: https://github.com/projectblacklight/blacklight_advanced_search/blob/v8.0.0.alpha2/lib/blacklight_advanced_search/advanced_query_parser.rb
module BlacklightAdvancedSearch
  class QueryParser
    # See lib/trln_argon/argon_search_builder/clause_count.rb
    # Max terms allowed in each field before the query gets truncated.
    MAX_TERMS_PER_FIELD =
      {
        'all_fields': 9,
        'title': 19,
        'author': 27,
        'subject': 132,
        'isbn_issn': 117,
        'default': 100
      }.with_indifferent_access

    def keyword_queries_adjusted_for_truncation(keyword_queries)
      # If we're likely to go over our Solr query clause limit...
      while estimated_solr_clauses_total(keyword_queries) > 4096
        adjusted_keyword_queries = keyword_queries.dup

        # Take away a term from the first field that has 2+ and try again.
        # This should truncate the most expensive fields first (all_fields, title)
        # and iterate until we're under the threshold.

        field_to_truncate = adjusted_keyword_queries.find { |clause| query_length(clause[:query]) > 1 }
        field_to_truncate[:query] = remove_one_term(field_to_truncate[:query])
        keyword_queries_adjusted_for_truncation(adjusted_keyword_queries)
      end

      keyword_queries
    end

    def process_query(config)
      queries = keyword_queries_adjusted_for_truncation(keyword_queries).map do |clause|
        field = clause[:field]
        query = clause[:query]
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

    def query_length(query)
      query.split(/\b/).select { |x| x.match?(/\w/) }.length
    end

    def truncate_query(query, length)
      query.truncate_words(length, separator: /\W+/, omission: '')
    end

    # Cumulative total of the Solr query clauses the current query would likely require.
    def estimated_solr_clauses_total(keyword_queries)
      total_clauses = 0
      keyword_queries.map do |clause|
        total_clauses += estimated_solr_clauses_for_field(clause)
      end
      total_clauses
    end

    def estimated_solr_clauses_for_field(clause)
      query_length(clause[:query]) * estimated_solr_clauses_per_term(clause[:field])
    end

    def estimated_solr_clauses_per_term(field)
      field_clause_multipliers.fetch(field, field_clause_multipliers[:default])
    end

    # Roughly how many Solr clauses will each term present in a given field consume?
    # The total query has to be under 4096 or Solr will break & the query will fail
    def field_clause_multipliers
      MAX_TERMS_PER_FIELD.transform_values { |term_count| 4096 / term_count }
    end

    def remove_one_term(query)
      truncate_query(query, query_length(query) - 1)
    end
  end
end
