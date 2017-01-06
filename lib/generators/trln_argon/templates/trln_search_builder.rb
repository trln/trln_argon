class TrlnSearchBuilder < Blacklight::SearchBuilder

  include Blacklight::Solr::SearchBuilderBehavior
  include TrlnArgon::TrlnSearchBuilderBehavior

  # self.default_processor_chain += [:rollup_duplicate_records]

end
