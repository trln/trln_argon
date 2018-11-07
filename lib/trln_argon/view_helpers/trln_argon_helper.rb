require 'trln_argon/view_helpers/document_export_helper'
require 'trln_argon/view_helpers/facets_helper'
require 'trln_argon/view_helpers/names_helper'
require 'trln_argon/view_helpers/search_scope_toggle_helper'
require 'trln_argon/view_helpers/subjects_helper'
require 'trln_argon/view_helpers/syndetics_helper'
require 'trln_argon/view_helpers/work_entry_helper'

module TrlnArgon
  module ViewHelpers
    # Shared helpers for TRLN Argon based applicatilns
    # Methods can be overridden in the local application
    # in app/helpers/trln_argon_helper.rb
    module TrlnArgonHelper
      include DocumentExportHelper
      include FacetsHelper
      include NamesHelper
      include SearchScopeToggleHelper
      include SubjectsHelper
      include SyndeticsHelper
      include WorkEntryHelper

      def filter_scope_name
        t("trln_argon.institution.#{TrlnArgon::Engine.configuration.local_institution_code}.short_name")
      end

      def advanced_search_url(options = {})
        blacklight_advanced_search_engine.url_for(options.merge(controller: 'advanced', action: 'index'))
      end

      def institution_code_to_short_name(options = {})
        options[:value].map do |val|
          t("trln_argon.institution.#{val}.short_name", default: val)
        end.to_sentence
      end

      def auto_link_values(options = {})
        options[:value].map { |value| auto_link(value) }.to_sentence.html_safe
      end

      def entry_name(count)
        entry = t('blacklight.entry_name.default')
        count.to_int == 1 ? entry : entry.pluralize
      end

      def institution_short_name
        t("trln_argon.institution.#{TrlnArgon::Engine.configuration.local_institution_code}.short_name")
      end

      def institution_long_name
        t("trln_argon.institution.#{TrlnArgon::Engine.configuration.local_institution_code}.long_name")
      end

      def consortium_short_name
        t('trln_argon.consortium.short_name')
      end

      def consortium_long_name
        t('trln_argon.consortium.long_name')
      end

      def item_availability_display(item)
        case item['status']
        when /^available/i
          'item-available'
        when /^checked out/i, /\blost\b/i, /^missing/i
          'item-not-available'
        when /(?:in-)?library use only/i
          'item-library-only'
        else
          'item-availability-misc'
        end
      end

      def item_due_date(item)
        return '' unless item.key?('due_date')
        dfmt = item['due_date'].to_date.strftime('%m/%d/%Y')
        "(Due #{dfmt})"
      rescue StandardError
        # not a date?
        "(Due #{item['due_date']})"
      end

      def map_argon_code(inst, context, value)
        TrlnArgon::LookupManager.instance.map([inst, context, value].join('.'))
      end

      def call_number_display(item)
        return '' if item.nil? || item.empty? || !item.respond_to?(:fetch)
        r = item.fetch('call_no', '')
        r << " #{item['vol']}" if item.key?('vol')
        r << " #{item['copy_no']}" if item.key?('copy_no')
        r
      end

      def item_notes_display(item)
        [*item.fetch('notes', [])].collect do |n|
          content_tag(:span, n, class: 'item-note')
        end.join('<br />').html_safe
      end

      def holding_notes_display(holding)
        holding.fetch('notes', []).collect do |n|
          content_tag(:span, n, class: 'holding-note')
        end.join('<br />').html_safe
      end

      def location_filter_display(value = '')
        values = value.split(':')

        values.map do |code|
          map_argon_code(values.first, 'facet', code)
        end.join(I18n.t('trln_argon.search_constraints.location_separator'))
      end

      def call_number_filter_display(value = '')
        value.gsub('|', I18n.t('trln_argon.search_constraints.call_number_separator'))
      end

      def show_configured_fields_and_values(config, document)
        config.map do |field_name, field|
          next unless document_has_value?(document, field)
          { field: field_name,
            label: field.label,
            value: presenter(document).field_value(field) }
        end.compact
      end

      def link_to_secondary_urls(options = {})
        options[:value].map do |url|
          link_text = if url[:text].present?
                        url[:text]
                      else
                        url[:href]
                      end
          link_to link_text, url[:href]
        end.join('<br />').html_safe
      end

      def link_to_primary_url(url_hash)
        return if url_hash[:href].blank?
        if url_hash[:type] == 'findingaid'
          link_to(url_hash[:href], class: "link-type-#{url_hash[:type]}", target: '_blank') do
            '<i class="fa fa-archive" aria-hidden="true"></i>'.html_safe + primary_url_text(url_hash)
          end
        else
          link_to(url_hash[:href], class: "link-type-#{url_hash[:type]}", target: '_blank') do
            '<i class="fa fa-external-link" aria-hidden="true"></i>'.html_safe + primary_url_text(url_hash)
          end
        end
      end

      def add_icon_to_action_label(document_action_config)
        if document_action_config.key?(:icon)
          content_tag(:i, '', class: "glyphicon #{document_action_config[:icon]}", 'aria-hidden' => 'true') + ' ' +
            document_action_label(document_action_config.key, document_action_config).html_safe
        else
          document_action_label(document_action_config.key, document_action_config).html_safe
        end
      end

      def join_with_commas(options = {})
        options[:value].join(', ')
      end

      def display_facet_hit_count(the_facet, the_value)
        hits = facets_from_request.select { |f| f.name == the_facet }
                                  .map(&:items)
                                  .first
                                  .select { |i| i.value == the_value }
                                  .map(&:hits)
                                  .first
        hits.present? ? number_with_delimiter(hits, delimiter: ',') : '0'
      end

      def link_to_fielded_keyword_search(options = {})
        options[:value].map do |v|
          query = { search_field: options[:config].search_field, q: v }
          link_to v, search_catalog_path(query)
        end.join('<br/>').html_safe
      end

      def add_thumbnail(document, size: :small)
        if document.thumbnail_urls.any?
          image_tag(
            document.thumbnail_urls.first.fetch(:href, ''),
            class: 'coverImage', onerror: "this.style.display = 'none';", alt: 'cover image'
          )
        else
          cover_image(document, size: size) do |url|
            image_tag(url.to_s, class: 'coverImage', onerror: "this.style.display = 'none';", alt: 'cover image')
          end
        end
      end

      private

      def primary_url_text(url_hash)
        return url_hash[:text] if url_hash[:text].present?
        I18n.t('trln_argon.links.online_access')
      end

      def online_access_link_text(url_hrefs, url_text)
        if url_text && url_text.count == url_hrefs.count
          url_text
        else
          [t('trln_argon.links.online_access')] * url_hrefs.count
        end
      end

      def holdings_have_notes?(holdings)
        return false if holdings.nil? || holdings.empty? || !holdings.respond_to?(:fetch)
        holdings.any? { |_loc_b, loc_narrow_map| holdings_location_has_notes?(loc_narrow_map) }
      end

      def holding_has_notes?(holding)
        return false if holding.nil? || holding.empty? || !holding.respond_to?(:fetch)
        holding.any? { |i| !i.fetch('notes', '').empty? }
      end

      # Tests whether a given holdings for a broad location
      # has notes to show
      def holdings_location_has_notes?(holdings_loc)
        return false if holdings_loc.nil? || holdings_loc.empty?
        holdings_loc.any? do |_loc_n, item_data|
          items_have_notes?(item_data['items'])
        end
      end

      # tests whether there are notes for any of the items
      # in an array
      def items_have_notes?(items)
        return false if items.nil? || items.empty?
        items.any? { |i| !i.fetch('notes', '').empty? }
      end
    end
  end
end
