module TrlnArgon
  module ViewHelpers
    module WorkEntryHelper
      def work_entry_display(options = {})
        assemble_work_entry_list_value(options[:value]).map do |work|
          content_tag(:li, work.html_safe, class: options[:field])
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
        "#{work[:label]}: "
      end

      def work_entry_author(work)
        return if work[:author].empty?
        link_to(work[:author],
                search_catalog_path(search_field: 'author', q: work[:author]),
                class: 'progressive-link')
      end

      def work_entry_linking(work)
        return if work[:title_linking].empty?
        "#{build_work_entry_title_links(work[:title_linking])} "
      end

      def work_entry_title_variation(work)
        return if work[:title_variation].empty?
        "(Some editions have title: #{work[:title_variation]}) "
      end

      def work_entry_details(work)
        return if work[:details].empty?
        "#{work[:details]} "
      end

      def work_entry_isbn(work)
        return if work[:isbn].empty?
        "ISBN: #{work[:isbn].join(', ')} "
      end

      def work_entry_issn(work)
        return if work[:issn].empty?
        "ISSN: #{work[:issn]}"
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
          sr_span = content_tag(:span, sr_only_segment, class: 'sr-only')
        end
        "#{sr_span} #{last_segment}"
      end

      def work_entry_link_url(params_segments)
        search_catalog_path(params_segments.merge(op: 'AND', search_field: 'advanced'))
      end
    end
  end
end
