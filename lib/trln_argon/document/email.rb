module TrlnArgon
  module Document
    module Email
      def to_email_text
        email_hash.map do |key, values|
          next unless values.reject(&:blank?).any?
          "\n" + I18n.t("trln_argon.email.label.#{key}") +
            ":\n\s\s#{values.reject(&:blank?).join("\n\s\s")}"
        end.compact.join("\n")
      end

      def email_hash
        @email_hash ||= Hash[email_field_mapping.map { |key, value| [key, [*call_or_fetch_value(value)]] }]
      end

      # TODO: DRY -- add to SolrDocument.rb?
      def call_or_fetch_value(value)
        value.respond_to?(:call) ? value.call : fetch(value, '')
      end
    end
  end
end
