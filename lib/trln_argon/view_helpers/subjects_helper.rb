module TrlnArgon
  module ViewHelpers
    module SubjectsHelper
      def list_of_linked_subjects_segments(options = {})
        link_to_subject_segments(options).map do |subject|
          content_tag(:li, subject, class: options[:field])
        end.join('').html_safe
      end

      def link_to_subject_segments(options = {})
        options[:value].map { |subject| build_segment_links(subject).html_safe }
      end

      def build_segment_links(segments_string, delimiter = ' -- ')
        segments = segments_string.split(delimiter)
        subject_hierarchy = array_to_hierarchy(segments, delimiter)
        zipped_segments = segments.zip(subject_hierarchy)
        linked_segments = zipped_segments.map { |segment| segment_begins_with_link(segment, delimiter) }.join
        linked_segments
      end

      def segment_begins_with_link(segment_hierarchy_pair, delimiter = ' -- ')
        params = { begins_with: { TrlnArgon::Fields::SUBJECTS_FACET => Array(segment_hierarchy_pair.last) } }
        params[:local_filter] = local_filter_applied?.to_s
        link_to(search_action_url(params),
                title: CGI.escapeHTML(segment_hierarchy_pair.last),
                class: 'progressive-link') do
          segment_link_content(segment_hierarchy_pair, delimiter).html_safe
        end
      end

      def segment_link_content(segment_hierarchy_pair, delimiter = ' -- ')
        sr_only_segment = segment_hierarchy_pair.last.sub(segment_hierarchy_pair.first, '')
        if sr_only_segment.present?
          sr_span = content_tag(:span,
                                CGI.escapeHTML(sr_only_segment.chomp(delimiter).to_s),
                                class: 'sr-only')
          apply_delim = delimiter
        end
        "#{sr_span}#{apply_delim}#{CGI.escapeHTML(segment_hierarchy_pair.first)}"
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
end
