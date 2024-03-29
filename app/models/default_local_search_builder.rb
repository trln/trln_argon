class DefaultLocalSearchBuilder < SearchBuilder
  self.default_processor_chain += %i[wildcard_char_strip
                                     disable_boolean_for_all_caps
                                     min_match_for_cjk
                                     min_match_for_titles
                                     min_match_for_boolean
                                     show_only_local_holdings
                                     only_home_facets
                                     author_boost
                                     subjects_boost
                                     add_document_ids_query
                                     add_solr_debug
                                     clause_count]
end
