module TrlnArgon
  module DocumentExtensions
    module Email
      def to_email_text
        email_hash.map do |key, values|
          next unless values.reject(&:blank?).any?
          "\n" + I18n.t("trln_argon.email.label.#{key}") +
            ":\n\s\s#{values.reject(&:blank?).join("\n\s\s")}"
        end.compact.join("\n")
      end

      def email_hash
        @email_hash ||= Hash[email_field_mapping.map do |key, value|
          [key, [*call_or_fetch_value(value)]]
        end]
      end
    end
  end
end
