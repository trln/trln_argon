require 'trln_argon/engine'
require 'trln_argon/version'

module TrlnArgon
  autoload :Lookups, 'trln_argon/mappings'
  autoload :LookupManager, 'trln_argon/mappings'
  autoload :MappingsGitFetcher, 'trln_argon/mappings'
  require 'trln_argon/controller_override'
  require 'trln_argon/field'
  require 'trln_argon/fields'
  require 'trln_argon/helpers/blacklight_helper_behavior'
  require 'trln_argon/helpers/catalog_helper_behavior'
  require 'trln_argon/helpers/trln_argon_helper_behavior'
  require 'trln_argon/helpers/render_constraints_helper_behavior'
  require 'trln_argon/trln_search_builder_behavior'
  autoload :ItemDeserializer, 'trln_argon/item_deserializer.rb'
  autoload :SolrDocument, 'trln_argon/solr_document.rb'
end
