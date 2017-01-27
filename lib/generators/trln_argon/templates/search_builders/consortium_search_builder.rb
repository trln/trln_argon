class ConsortiumSearchBuilder < SearchBuilder

  self.default_processor_chain += [:rollup_duplicate_records]

end
