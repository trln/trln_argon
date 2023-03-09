module TrlnArgon
  module SolrDocument
    # In addition to marking the imprint (resulting) value as
    # "html_safe", work is done to ensure < and > are preserved...
    #
    # ...because some catalogers are adding &lt; and &gt;
    # in subfield $3.
    #
    # DEVELOPERS' NOTE
    # We are aware that we're possibly violating the spirit
    # of the "Single Responsibily Principle" with this
    # approach, but it was either here, or taking a
    # deep-dive at parsing through FieldPresenters and/or
    # ShowPresenters to determine if we are displaying
    # the "imprint" field.
    module Imprint
      def imprint_main_for_header_display
        imprint_main.reverse.map do |imprint|
          imprint_entry(imprint)
        end.join(' / ')
      end

      def imprint_multiple_for_display
        imprint_multiple.map { |imprint| imprint_entry(imprint, escape_label: false) }
                        .concat(imprint_main.map { |imprint| imprint_entry(imprint, escape_label: false) })
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

      def imprint_entry(imprint, escape_label: false)
        [imprint_type(imprint),
         imprint_label(imprint, escape_label: escape_label),
         imprint_value(imprint)].compact.join(': ')
      end

      def imprint_type(imprint)
        return if imprint[:type].blank? || I18n.t("trln_argon.imprint_type.#{imprint[:type]}").blank?
        I18n.t("trln_argon.imprint_type.#{imprint[:type]}")
      end

      # when needed, replace < and > with their intended 
      # escaped &lt; and &gt; string values.
      def imprint_label(imprint, escape_label: false)
        return if imprint[:label].blank?
        return imprint[:label] unless escape_label
        imprint[:label].gsub! '<', ' &lt;'
        imprint[:label].gsub '>', '&gt;'
      end

      def imprint_value(imprint)
        return if imprint[:value].blank?
        imprint[:value]
      end
    end
  end
end
