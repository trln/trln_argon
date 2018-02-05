require 'trln_argon/engine'
require 'trln_argon/version'

module TrlnArgon
  autoload :ControllerOverride, 'trln_argon/controller_override'
  autoload :DocumentExtensions, 'trln_argon/document_extensions'
  autoload :Field, 'trln_argon/field'
  autoload :Fields, 'trln_argon/fields'
  autoload :ItemDeserializer, 'trln_argon/item_deserializer'
  autoload :LookupManager, 'trln_argon/mappings'
  autoload :Lookups, 'trln_argon/mappings'
  autoload :MappingsGitFetcher, 'trln_argon/mappings'
  autoload :ArgonSearchBuilder, 'trln_argon/argon_search_builder'
  autoload :SolrDocument, 'trln_argon/solr_document'
  autoload :SyndeticsData, 'trln_argon/syndetics_data'
  autoload :ViewHelpers, 'trln_argon/view_helpers'
end
