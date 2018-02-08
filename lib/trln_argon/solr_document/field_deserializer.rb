module TrlnArgon
  module SolrDocument
    module FieldDeserializer
      def deserialize_solr_field(solr_field, hash_spec = {}, required_key = nil)
        deserialized_fields = [*self[solr_field]].map do |serialized_value|
          deserialized_hash = begin
            JSON.parse(serialized_value.to_s)
          rescue JSON::ParserError
            {}
          end
          hash_spec.merge(deserialized_hash.symbolize_keys)
        end
        return deserialized_fields if required_key.nil?
        deserialized_fields.delete_if { |h| h[required_key].empty? }
      end
    end
  end
end
