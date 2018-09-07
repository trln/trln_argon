module TrlnArgon
  module DocumentExtensions
    module Sms
      def to_sms_text
        sms_hash.map do |key, values|
          next unless values.reject(&:blank?).any?
          I18n.t("trln_argon.sms.label.#{key}") +
            ": #{values.reject(&:blank?).join("\n")}"
        end.compact.join("\n")
      end

      def sms_hash
        @sms_hash ||= Hash[sms_field_mapping.map do |key, value|
          [key, [*call_or_fetch_value(value)]]
        end]
      end
    end
  end
end
