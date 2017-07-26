# Mixin for SolrDocument to allow deserializing item information
# to a userful structure
module TrlnArgon::ItemDeserializer

  def deserialize
    (self['items_a'] || ['{}']).map {|d| JSON.parse(d) }
      .group_by {|rec| rec['library'] }
  end
          
  def read_items
    self['items_map'] ||= deserialize
  end
end
