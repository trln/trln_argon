class LocalOnlySearchBuilder < SearchBuilder
  self.default_processor_chain += [:show_only_local_holdings]
end
