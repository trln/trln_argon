require_relative './syndetics_helpers'

module TrlnArgon
  # Shared helpers for TRLN Argon based applicatilns
  # Methods can be overridden in the local application
  # in app/helpers/trln_argon_helper.rb
  module TrlnArgonHelperBehavior
    include TrlnArgon::SyndeticsHelpers

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

    def filter_scope_name
      if controller_name == 'bookmarks'
        t('trln_argon.scope_name.bookmarks')
      else
        local_filter_applied? ? institution_short_name : consortium_short_name
      end
    end

    def url_href_with_url_text_link(options = {})
      text = online_access_link_text(options[:value], options[:document][TrlnArgon::Fields::URL_TEXT])
      hrefs_and_text = options[:value].zip(text)
      hrefs_and_text.map do |href_text_pair|
        link_to href_text_pair.last, href_text_pair.first
      end.join('; ').html_safe
    end

    def map_argon_code(inst, context, value)
      TrlnArgon::LookupManager.instance.map([inst, context, value].join('.'))
    end

    def link_to_subject_segments(options = {})
      options[:value].map { |subject| build_segment_links(subject) }.join('<br />').html_safe
    end

    def location_filter_display(value = '')
      values = value.split(':')

      values.map do |code|
        map_argon_code(values.first, 'facet', code)
      end.join(I18n.t('trln_argon.search_constraints.location_separator'))
    end

    private

    def online_access_link_text(url_hrefs, url_text)
      if url_text && url_text.count == url_hrefs.count
        url_text
      else
        [t('trln_argon.online_access')] * url_hrefs.count
      end
    end

    def build_segment_links(segments_string, delimiter = ' -- ')
      segments = segments_string.split(delimiter)
      subject_hierarchy = array_to_hierarchy(segments, delimiter)
      zipped_segments = segments.zip(subject_hierarchy)
      linked_segments = zipped_segments.map { |segment| segment_begins_with_link(segment) }.join(delimiter)
      linked_segments
    end

    def segment_begins_with_link(segment_hierarchy_pair)
      params = { begins_with: { TrlnArgon::Fields::SUBJECTS_FACET => Array(segment_hierarchy_pair.last) } }
      params[:local_filter] = local_filter_applied?.to_s
      link_to segment_hierarchy_pair.first, search_action_url(params)
    end

    def array_to_hierarchy(args, delimiter = ' -- ')
      result = []
      args.each_with_object([]) do |part, acc|
        acc << part
        result << acc.join(delimiter)
      end
      result
    end
  end
end
