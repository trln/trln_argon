# Mixin for SolrDocument to allow deserializing item information
# to a userful structure
module TrlnArgon
  module ItemDeserializer
    def deserialize
      (self[TrlnArgon::Fields::ITEMS] || ['{}']).map { |d| JSON.parse(d) }
                                                .group_by { |rec| rec['library'] }
    end

    def read_items
      @read_items ||= deserialize
    end
  end
end
