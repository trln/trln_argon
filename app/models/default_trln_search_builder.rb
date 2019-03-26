class DefaultTrlnSearchBuilder < SearchBuilder
  self.default_processor_chain += %i[wildcard_char_strip
                                     min_match_for_cjk
                                     min_match_for_boolean
                                     rollup_duplicate_records
                                     only_home_facets
                                     subjects_boost
                                     get_shared_bookmark_ids]
