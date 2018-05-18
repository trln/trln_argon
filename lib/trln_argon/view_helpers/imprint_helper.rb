module TrlnArgon
  module ViewHelpers
    module ImprintHelper
      def imprint_main(options = {})
        options[:document].imprint_main.map do |imprint|
          imprint_entry(imprint)
        end.join('<br />').html_safe
      end

      def imprint_multiple(options = {})
        options[:document].imprint_multiple.concat(options[:document].imprint_main).uniq.map do |imprint|
          imprint_entry(imprint)
        end.join('<br />').html_safe
      end

      private

      def imprint_entry(imprint)
        [imprint_type(imprint),
         imprint_label(imprint),
         imprint_value(imprint)].compact.join(': ')
      end

      def imprint_type(imprint)
        return if imprint[:type].blank? || t("trln_argon.imprint_type.#{imprint[:type]}").blank?
        content_tag(:span, t("trln_argon.imprint_type.#{imprint[:type]}"), class: 'imprint-type')
      end

      def imprint_label(imprint)
        return if imprint[:label].blank?
        content_tag(:span, imprint[:label], class: 'imprint-label')
      end

      def imprint_value(imprint)
        return if imprint[:value].blank?
        imprint[:value]
      end
    end
  end
end
