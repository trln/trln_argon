class LocalSearchBuilder < Blacklight::SearchBuilder

  include Blacklight::Solr::SearchBuilderBehavior
  include TrlnArgon::TrlnSearchBuilderBehavior

  self.default_processor_chain += [:show_only_local_holdings]

end
