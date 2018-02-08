require 'openurl'

module TrlnArgon
  module DocumentExtensions
    module OpenurlCtxKev
      def self.extended(document)
        document.will_export_as(:openurl_ctx_kev, 'application/x-openurl-ctx-kev')
      end

      def export_as_openurl_ctx_kev
        ctx_object
        ctx_referent
        ctx_referent_format
        ctx_referent_identifiers
        ctx_referent_metadata

        ctx_object.kev
      end

      private

      def ctx_object
        @ctx_object ||= OpenURL::ContextObject.new
      end

      def ctx_referent
        ctx_object.referent = OpenURL::Book.new
      end

      def ctx_referent_format
        ctx_object.referent.set_format(
          call_or_fetch_value(openurl_ctx_kev_field_mapping[:format])
        )
      end

      def ctx_referent_identifiers
        openurl_ctx_kev_field_mapping[:identifiers].each do |id|
          ctx_object.referent.add_identifier(call_or_fetch_value(id))
        end
      end

      def ctx_referent_metadata
        openurl_ctx_kev_field_mapping[:metadata].each do |key, value|
          metadata_value = [*call_or_fetch_value(value)]

          # Author fields are left multivalued; other values joined.
          unless %i[aulast aufirst auinit auinit1 auinitm ausuffix au aucorp].include?(key)
            metadata_value = metadata_value.join(' ')
          end

          ctx_object.referent.set_metadata(key.to_s, metadata_value)
        end
      end
    end
  end
end
