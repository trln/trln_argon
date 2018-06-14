module TrlnArgon
  module ViewHelpers
    module NamesHelper
      def names_display(options = {})
        assemble_names_list_value(options[:value]).map do |work|
          content_tag(:li, work.html_safe, class: options[:field])
        end.join('').html_safe
      end

      def assemble_names_list_value(value)
        value.map do |name|
          [names_name(name),
           names_rel(name)].compact.join.strip
        end
      end

      def names_name(name)
        return if name[:name].empty?
        search_params = { search_field: 'author', q: name[:name] }
        search_params[:local_filter] = local_filter_applied? ? 'true' : 'false'
        link_to(CGI.escapeHTML(name[:name]),
                search_action_url(search_params))
      end

      def names_rel(name)
        return if name[:rel].empty?
        ", #{CGI.escapeHTML(name[:rel])}"
      end
    end
  end
end
