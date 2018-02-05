module TrlnArgon
  module DocumentExtensions
    module Ris
      def self.extended(document)
        document.will_export_as(:ris, 'application/x-research-info-systems')
      end

      def export_as_ris
        lines = ris_hash.keys
                        .select { |key| ris_hash[key].present? }
                        .flat_map { |key| render_ris_key_value(key, ris_hash[key]) }
        lines << 'ER  - '
        lines.compact.join("\r\n") # The RIS spec says use \r\n
      end

      private

      def render_ris_key_value(key, value)
        [*value].map { |v| "#{key}  - #{v}" }
      end

      def ris_hash
        @ris_hash ||= Hash[ris_field_mapping.map { |key, value| [key, call_or_fetch_value(value)] }]
      end
    end
  end
end
