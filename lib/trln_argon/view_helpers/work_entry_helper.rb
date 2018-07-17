module TrlnArgon
  module ViewHelpers
    module WorkEntryHelper
      def work_entry_display(options = {})
        assemble_work_entry_list_value(options[:value]).map do |work|
          content_tag :dd, class: options[:field] do
            content_tag :span, work.html_safe, class: 'progressive-link-wrapper'
          end
        end.join('').html_safe
      end

      private

      def assemble_work_entry_list_value(value)
        value.map do |work|
          [work_entry_label(work),
           work_entry_author(work),
           work_entry_linking(work),
           work_entry_title_variation(work),
           work_entry_details(work),
           work_entry_isbn(work),
           work_entry_issn(work)].compact.join.strip
        end
      end

      def work_entry_label(work)
        return if work[:label].empty?
        "#{CGI.escapeHTML(work[:label])}: "
      end

      def work_entry_author(work)
        return if work[:author].empty?
        search_params = { search_field: 'author', q: work[:author] }
        link_to(CGI.escapeHTML(work[:author]),
                search_action_url(search_params),
                class: 'progressive-link')
      end

      def work_entry_linking(work)
        return if work[:title_linking].empty?
        "#{build_work_entry_title_links(work[:title_linking])} "
      end

      def work_entry_title_variation(work)
        return if work[:title_variation].empty?
        "(Some editions have title: #{CGI.escapeHTML(work[:title_variation])}) "
      end

      def work_entry_details(work)
        return if work[:details].empty?
        "#{CGI.escapeHTML(work[:details])} "
      end

      def work_entry_isbn(work)
        return if work[:isbn].empty?
        isbn = work[:isbn].map { |v| CGI.escapeHTML(v) }.join(', ')
        "ISBN: #{isbn} "
      end

      def work_entry_issn(work)
        return if work[:issn].empty?
        "ISSN: #{CGI.escapeHTML(work[:issn])}"
      end

      def build_work_entry_title_links(title_linking)
        title_linking.map do |segment|
          link_to(work_entry_link_body(segment[:display_segments]).html_safe,
                  work_entry_link_url(segment[:params]),
                  class: 'progressive-link')
        end.join('')
      end

      def work_entry_link_body(title_segments)
        sr_only_segment = title_segments[0..-1].join(' ')
        last_segment = title_segments[-1]
        if sr_only_segment != last_segment
          sr_span = content_tag(:span, CGI.escapeHTML(sr_only_segment), class: 'sr-only')
        end
        "#{sr_span} #{CGI.escapeHTML(last_segment)}"
      end

      def work_entry_link_url(params_segments)
        search_action_url(params_segments.merge(op: 'AND', search_field: 'advanced'))
      end
    end
  end
end
