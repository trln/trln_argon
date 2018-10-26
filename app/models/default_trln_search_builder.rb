class DefaultTrlnSearchBuilder < SearchBuilder
  self.default_processor_chain += %i[min_match_for_cjk
                                     min_match_for_boolean
                                     rollup_duplicate_records
                                     only_home_facets]
end
