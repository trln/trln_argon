module TrlnArgon
  module SolrDocument
    module Imprint
      def imprint_main_for_header_display
        imprint_main.reverse.map do |imprint|
          imprint_entry(imprint)
        end.join(' / ')
      end

      def imprint_multiple_for_display
        imprint_multiple.map { |imprint| imprint_entry(imprint) }
                        .concat(imprint_main.map { |imprint| imprint_entry(imprint) })
                        .uniq
                        .join('<br />').html_safe
      end

      def imprint_main_to_text
        @imprint_main_to_text ||= imprint_main.map do |imprint|
          imprint_entry(imprint)
        end
      end

      def imprint_main
        @imprint_main ||= deserialize_solr_field(TrlnArgon::Fields::IMPRINT_MAIN,
                                                 { type: '', label: '', value: '' },
                                                 :value)
      end

      def imprint_multiple
        @imprint_multiple ||= deserialize_solr_field(TrlnArgon::Fields::IMPRINT_MULTIPLE,
                                                     { type: '', label: '', value: '' },
                                                     :value)
      end

      private

      def imprint_entry(imprint)
        [imprint_type(imprint),
         imprint_label(imprint),
         imprint_value(imprint)].compact.join(': ')
      end

      def imprint_type(imprint)
        return if imprint[:type].blank? || I18n.t("trln_argon.imprint_type.#{imprint[:type]}").blank?
        I18n.t("trln_argon.imprint_type.#{imprint[:type]}")
      end

      def imprint_label(imprint)
        return if imprint[:label].blank?
        imprint[:label]
      end

      def imprint_value(imprint)
        return if imprint[:value].blank?
        imprint[:value]
      end
    end
  end
end
