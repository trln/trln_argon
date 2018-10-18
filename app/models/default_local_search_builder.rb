class DefaultLocalSearchBuilder < SearchBuilder
  self.default_processor_chain += %i[min_match_for_cjk
                                     min_match_for_boolean
                                     show_only_local_holdings
                                     only_home_facets]
end
