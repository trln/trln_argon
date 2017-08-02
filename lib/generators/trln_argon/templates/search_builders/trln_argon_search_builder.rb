class TrlnArgonSearchBuilder < SearchBuilder
  self.default_processor_chain += %i[apply_local_filter boost_isxn_matches]
end
