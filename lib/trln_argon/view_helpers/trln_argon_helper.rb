require 'trln_argon/view_helpers/document_export_helper'
require 'trln_argon/view_helpers/imprint_helper'
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
      include ImprintHelper
      include SubjectsHelper
      include SyndeticsHelper
      include WorkEntryHelper

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

      def map_argon_code(inst, context, value)
        TrlnArgon::LookupManager.instance.map([inst, context, value].join('.'))
      end

      def call_number_display(item)
        return '' if item.nil? || item.empty? || !item.respond_to?(:fetch)
        r = item.fetch('call_no', '')
        r << " #{item['vol']}" if item.key?('vol')
        r << " c.#{item['copy_no']}" if item.key?('copy_no')
        r
      end

      def item_notes_display(item)
        item.fetch('notes', []).collect do |n|
          "<span class='item-note'>#{n}</span>"
        end.join('<br />').html_safe
      end

      def location_filter_display(value = '')
        values = value.split(':')

        values.map do |code|
          map_argon_code(values.first, 'facet', code)
        end.join(I18n.t('trln_argon.search_constraints.location_separator'))
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
        link_to(primary_url_text(url_hash), url_hash[:href], class: "link-type-#{url_hash[:type]}")
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

      def join_with_br(options = {})
        options[:value].join('<br />').html_safe
      end

      private

      def primary_url_text(url_hash)
        return url_hash[:text] if url_hash[:text].present?
        I18n.t('trln_argon.online_access')
      end

      def online_access_link_text(url_hrefs, url_text)
        if url_text && url_text.count == url_hrefs.count
          url_text
        else
          [t('trln_argon.online_access')] * url_hrefs.count
        end
      end

      def holdings_have_notes?(holdings)
        return false if holdings.nil? || holdings.empty? || !holdings.respond_to?(:fetch)
        holdings.any? { |_loc_b, loc_narrow_map| holdings_location_has_notes?(loc_narrow_map) }
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
