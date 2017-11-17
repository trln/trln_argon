class TrlnArgonSearchBuilder < SearchBuilder
  self.default_processor_chain += %i[apply_local_filter boost_isxn_matches begins_with_filter]
end
