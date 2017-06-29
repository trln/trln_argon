class TrlnArgonSearchBuilder < SearchBuilder
  self.default_processor_chain += [:apply_local_filter]
end
