module TrlnArgon
  module SolrDocument
    module SmsFieldMapping
      # Override this method in local models/solr_document.rb
      # to set local SMS field mappings.
      # By default it will fetch values from the specified Solr field.
      # (Use the Solr Field constants, e.g. TrlnArgon::Fields::FIELD_CONSTANT)
      # For more complex data mappings see proc examples.

      def sms_field_mapping
        @sms_field_mapping ||= {
          title: proc do
                   truncate(self[TrlnArgon::Fields::TITLE_MAIN].to_s, length: 50)
                 end,
          location: proc { holdings_to_text }
        }
      end
    end
  end
end
