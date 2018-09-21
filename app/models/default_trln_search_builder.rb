class DefaultTrlnSearchBuilder < SearchBuilder
  self.default_processor_chain += %i[rollup_duplicate_records
                                     begins_with_filter only_home_facets]
end
