module TrlnArgon
  module ViewHelpers
    module LinkHelper
      def primary_link_class
        'col-md-12 primary-url'
      end

      # Other and related links
      def link_to_secondary_urls(options = {})
        options[:value].map do |url|
          link_text = if url[:text].present? || url[:note].present?
                        [url[:text], url[:note]].compact.reject(&:empty?)
                      else
                        [url[:href]]
                      end
          link_to link_text.join(' - '), url[:href]
        end.join('<br />').html_safe
      end

      # Full Text Links -- for Local View
      def link_to_fulltext_url(url_hash)
        inst = TrlnArgon::Engine.configuration.local_institution_code
        link_to(url_hash[:href],
                class: "link-type-#{url_hash[:type]} link-restricted-#{inst}",
                target: '_blank') do
          '<i class="fa fa-external-link" aria-hidden="true"></i>'.html_safe + fulltext_link_text(url_hash)
        end
      end

      def fulltext_link_text(url_hash)
        return url_hash[:text] if url_hash[:text].present?
        I18n.t('trln_argon.links.online_access')
      end

      # Full Text Expanded Links -- for TRLN View
      def link_to_expanded_fulltext_url(url_hash, inst)
        return if url_hash[:href].blank?
        link_to(url_hash[:href],
                class: "link-type-#{url_hash[:type]} link-restricted-#{inst}",
                target: '_blank') do
          '<i class="fa fa-external-link" aria-hidden="true"></i>'.html_safe +
            expanded_fulltext_link_text(inst)
        end
      end

      def expanded_fulltext_link_text(inst)
        I18n.t('trln_argon.links.online_access_restricted',
               institution: institution_code_to_short_name(value: [inst]))
      end

      # Finding Aid Links
      def link_to_finding_aid(url_hash)
        link_to(url_hash[:href], class: "link-type-#{url_hash[:type]}", target: '_blank') do
          '<i class="fa fa-archive" aria-hidden="true"></i>'.html_safe + finding_aid_link_text(url_hash)
        end
      end

      def finding_aid_link_text(url_hash)
        return url_hash[:text] if url_hash[:text].present?
        I18n.t('trln_argon.links.finding_aid')
      end

      # Open Access Links
      def link_to_open_access(url_hash)
        link_to(url_hash[:href], class: "link-type-#{url_hash[:type]} link-open-access", target: '_blank') do
          '<i class="fa fa-external-link" aria-hidden="true"></i>'.html_safe + open_access_link_text(url_hash)
        end
      end

      def open_access_link_text(url_hash)
        return url_hash[:text] if url_hash[:text].present?
        I18n.t('trln_argon.links.open_access')
      end

      # Expanded View Open Access Links
      def expanded_link_to_open_access(url_hash)
        link_to(url_hash[:href], class: "link-type-#{url_hash[:type]} link-open-access", target: '_blank') do
          '<i class="fa fa-external-link" aria-hidden="true"></i>'.html_safe + expanded_open_access_link_text
        end
      end

      def expanded_open_access_link_text
        I18n.t('trln_argon.links.open_access')
      end

      # Boolean methods to control link display behavior
      def add_spacer_to_expanded_index_view?(document, inst)
        document.findingaid_urls.any? ||
          document.all_shared_and_local_fulltext_urls_by_inst.fetch(inst, []).to_a.any? ||
          document.all_open_access_urls_by_inst.fetch(inst, []).to_a.any?
      end

      def display_expanded_holdings_and_links?(document, local_doc, inst)
        document.all_shared_and_local_fulltext_urls_by_inst.fetch(inst, []).to_a.any? ||
          document.all_open_access_urls_by_inst.fetch(inst, []).to_a.any? ||
          display_items?(document: local_doc)
      end

      def display_expanded_links?(document, inst)
        document.all_shared_and_local_fulltext_urls_by_inst.fetch(inst, []).to_a.any? ||
          document.all_open_access_urls_by_inst.fetch(inst, []).to_a.any?
      end
    end
  end
end
