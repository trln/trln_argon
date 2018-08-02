class DefaultLocalSearchBuilder < SearchBuilder
  self.default_processor_chain += %i[escape_query_string
                                     show_only_local_holdings
                                     begins_with_filter]
end
