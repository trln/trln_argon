require 'trln_argon/engine'
require 'trln_argon/version'

module TrlnArgon
  autoload :IsbnIssnSearch, 'trln_argon/isbn_issn_search.rb'
  require 'trln_argon/controller_override'
  require 'trln_argon/field'
  require 'trln_argon/fields'
  require 'trln_argon/helpers/blacklight_helper_behavior'
  require 'trln_argon/helpers/catalog_helper_behavior'
  require 'trln_argon/helpers/trln_argon_helper_behavior'
  require 'trln_argon/trln_search_builder_behavior'
  autoload :ItemDeserializer, 'trln_argon/item_deserializer.rb'
end
