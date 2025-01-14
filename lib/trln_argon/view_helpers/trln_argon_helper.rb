require 'trln_argon/view_helpers/advanced_search_helper'
require 'trln_argon/view_helpers/debug_info_helper'
require 'trln_argon/view_helpers/document_export_helper'
require 'trln_argon/view_helpers/facets_helper'
require 'trln_argon/view_helpers/items_section_helper'
require 'trln_argon/view_helpers/link_helper'
require 'trln_argon/view_helpers/names_helper'
require 'trln_argon/view_helpers/search_scope_toggle_helper'
require 'trln_argon/view_helpers/show_view_helper'
require 'trln_argon/view_helpers/subjects_helper'
require 'trln_argon/view_helpers/work_entry_helper'

module TrlnArgon
  module ViewHelpers
    # Shared helpers for TRLN Argon based applicatilns
    # Methods can be overridden in the local application
    # in app/helpers/trln_argon_helper.rb
    module TrlnArgonHelper
      include AdvancedSearchHelper
      include DebugInfoHelper
      include DocumentExportHelper
      include FacetsHelper
      include ItemsSectionHelper
      include LinkHelper
      include NamesHelper
      include SearchScopeToggleHelper
      include ShowViewHelper
      include SubjectsHelper
      include WorkEntryHelper

      def filter_scope_name
        t("trln_argon.institution.#{TrlnArgon::Engine.configuration.local_institution_code}.short_name")
      end

      def advanced_search_url(options = {})
        url_for(options.merge(controller: 'catalog', action: 'advanced_search'))
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

      def no_results_inst_display
        TrlnArgon::Engine.configuration.sort_order_in_holding_list.split(', ')
                         .reject { |inst| inst == 'trln' }
                         .map { |inst_code| t("trln_argon.institution.#{inst_code}.short_name") }
                         .to_sentence(words_connector: ', ', last_word_connector: ', or ')
      end

      def item_due_date(item)
        return '' if item.fetch('due_date', '').blank?

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
        [item.fetch('call_no', nil),
         item.fetch('vol', nil),
         item.fetch('copy_no', nil)].compact.join(' ')
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
        value = value.first if value.is_a?(Array)
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

      def join_with_comma_semicolon_fallback(options = {})
        return options[:value].join('; ') if options[:value].any? { |v| v.include?(',') }

        options[:value].join(', ')
      end

      # @todo facets_from_request is removed in BL 8 https://github.com/projectblacklight/blacklight/commit/5b2def753dc3724bae5d3d4e70a69ed6453e185b
      def display_facet_hit_count(the_facet, the_value)
        hits = facets_from_request(facet_field_names, @response).select { |f| f.name == the_facet }
                                                                .map(&:items)
                                                                .first
                                                                .select { |i| i.value == the_value }
                                                                .map(&:hits)
                                                                .first
        hits.present? ? number_with_delimiter(hits, delimiter: ',') : '0'
      end

      def add_thumbnail(document, size: :small)
        return marc_thumbnail_tag(document) if document.thumbnail_urls.any?
        syndetics_thumbnail_tag(document, size)
      end

      private

      def marc_thumbnail_tag(document)
        image_tag(
          document.thumbnail_urls.first.fetch(:href, ''),
          class: 'coverImage', onerror: "this.style.display = 'none';", alt: ''
        )
      end

      def syndetics_thumbnail_tag(document, size)
        document.cover_image(size: size) do |url|
          image_tag(url.to_s, class: 'coverImage', onerror: "this.style.display = 'none';", alt: '')
        end
      end
    end
  end
end
