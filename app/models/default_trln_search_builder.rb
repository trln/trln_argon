class DefaultTrlnSearchBuilder < SearchBuilder
  self.default_processor_chain += %i[escape_query_string
                                     rollup_duplicate_records
                                     begins_with_filter]
end
