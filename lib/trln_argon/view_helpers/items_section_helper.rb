module TrlnArgon
  module ViewHelpers
    module ItemsSectionHelper
      def items_spacer_class
        'items-spacer col-md-12'
      end

      def items_wrapper_class
        'items-wrapper items-section-index col-md-12'
      end

      def item_class
        'item col-md-12'
      end

      def availability_class
        'available col-md-5'
      end

      def location_header_class
        'location-header col-md-12'
      end

      def institution_location_header_class
        'institution location-header col-md-12'
      end

      def location_narrow_group_class
        'location-narrow-group col-md-12'
      end

      def holdings_summary_wrapper_class
        'col-sm-12 summary-wrapper'
      end

      def holdings_note_class
        'holding-note col-md-12'
      end

      def url_note_wrapper_class
        'url-note-wrapper'
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

      def binary_availability_span_class(options = {})
        doc = options.fetch(:document, nil)
        if doc && doc.availability == 'Available'
          'item-available'
        elsif doc && doc.availability == 'Not Available'
          'item-not-available'
        else
          'item-available'
        end
      end

      def call_number_wrapper_class(_options = {})
        'col-md-5 col-sm-12 call-number-wrapper'
      end

      def status_wrapper_class(_options = {})
        'col-md-7 col-sm-12'
      end

      def item_note_wrapper_class(_options = {})
        'col-md-12'
      end

      def latest_received_wrapper_class(_opts = {})
        'col-md5 col-sm-12 latest-received-wrapper'
      end

      def display_holdings_summaries?(options = {})
        holdings = options.fetch('holdings', [])
        holdings.find { |h| h.fetch('summary', '').present? || h.fetch('notes', []).any? }.present?
      end

      def display_holdings_summary?(options = {})
        options.fetch('summary', '').present? || options.fetch('notes', []).any?
      end

      def display_holdings_well?(options = {})
        doc = options.fetch(:document, nil)
        doc &&
          (doc.findingaid_urls.any? ||
           doc.fulltext_urls.any? ||
           doc.open_access_urls.any? ||
           display_items?(document: doc) ||
           doc.shared_fulltext_urls.any?)
      end

      def display_items?(options = {})
        doc = options.fetch(:document, nil)
        return unless doc

        displayable_holdings = doc.holdings.map do |loc_b, loc_n_map|
          loc_n_map.reject do |loc_n, item_data|
            suppress_item?(loc_b: loc_b, loc_n: loc_n, item_data: item_data)
          end
        end
        displayable_holdings.flatten.reject(&:empty?).any?
      end

      def suppress_item?(options = {})
        loc_b = options.fetch(:loc_b, '')
        loc_n = options.fetch(:loc_n, '')
        item_data = options.fetch(:item_data, {})
        loc_b.blank? ||
          online_only_items?(loc_b: loc_b, loc_n: loc_n, item_data: item_data) ||
          no_items_no_holdings?(loc_b: loc_b, loc_n: loc_n, item_data: item_data) ||
          no_items_holdings_no_summary?(loc_b: loc_b, loc_n: loc_n, item_data: item_data)
      end

      def online_only_items?(options = {})
        loc_b = options.fetch(:loc_b, '')
        %w[ONLINE DUKIR].include?(loc_b)
      end

      def no_items_no_holdings?(options = {})
        item_data = options.fetch(:item_data, {})
        item_data.fetch('holdings', []).reject(&:empty?).empty? &&
          item_data.fetch('items', []).reject(&:empty?).empty?
      end

      def no_items_holdings_no_summary?(options = {})
        item_data = options.fetch(:item_data, {})
        holdings = item_data.fetch('holdings', []).reject(&:empty?)
        holdings.any? &&
          holdings.select { |j| j.fetch('summary', '').present? || j.fetch('notes', []).any? }.none? &&
          item_data.fetch('items').reject(&:empty?).none?
      end

      def add_spacer_above_items_section?(options = {})
        doc = options.fetch(:document, nil)
        doc &&
          display_items?(document: doc) &&
          (doc.findingaid_urls.any? ||
           doc.fulltext_urls.any? ||
           doc.shared_fulltext_urls.any? ||
           doc.open_access_urls.any?)
      end

      def get_item_id(item)
        item.key?('item_id') ? item['item_id'] : ''
      end

      def assign_item_id_as_id(item)
        item.key?('item_id') ? "id=\"item-#{CGI.escapeHTML(item['item_id'])}\"".html_safe : ''
      end

      def latest_received(doc, item_data)
        return [nil, nil] unless doc && item_data

        url = if doc.record_owner == 'unc' && item_data['holdings_id']
                format(
                  TrlnArgon::Engine.configuration.unc_latest_received_url,
                  local_id: doc['local_id'],
                  holdings_id: item_data['holdings_id'].upcase
                )
              end
        lr_text = url ? 'Latest Received' : item_data['latest_received_text']
        [lr_text, url]
      end
    end
  end
end
