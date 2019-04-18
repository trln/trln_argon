# Mixin for SolrDocument to allow deserializing item information
# to a userful structure
module TrlnArgon
  module ItemDeserializer
    include ActionView::Helpers::TextHelper

    def holdings
      @holdings ||= deserialize_holdings
    end

    def read_items
      @read_items ||= deserialize_items
    end

    # For Email, SMS, and other record export functions (Location and Call Number)
    def holdings_to_text
      @holdings_to_text ||= holdings.flat_map do |loc_b, loc_n_map|
        loc_n_map.map do |_loc_n, entries|
          I18n.t('trln_argon.item_location_plus_callnumber',
                 loc_b_display: TrlnArgon::LookupManager.instance.map("#{self.record_owner}.loc_b.#{loc_b}"),
                 call_number: entries.fetch('holdings', []).map { |e| e.fetch('call_no', '').strip }.join(', '))
        end
      end
    end

    # For RIS (Locations only)
    def locations_to_text
      @locations_to_text ||= holdings.flat_map do |loc_b, loc_n_map|
        loc_n_map.map do |_loc_n, entries|
          I18n.t('trln_argon.item_location',
                 loc_b_display: TrlnArgon::LookupManager.instance.map("#{self.record_owner}.loc_b.#{loc_b}"))
        end
      end
    end

    # For RIS (Call Numbers only)
    def callnumbers_to_text
      @callnumbers_to_text ||= holdings.flat_map do |loc_b, loc_n_map|
        loc_n_map.map do |_loc_n, entries|
          entries.fetch('holdings', []).map { |e| e.fetch('call_no', '').strip }.join(', ')
        end
      end
    end

    private

    def deserialize_items
      (self[TrlnArgon::Fields::ITEMS] || ['{}']).map { |d| JSON.parse(d) }
                                                .group_by { |rec| rec['loc_b'] }
    end

    def deserialize_holdings
      items = (self[TrlnArgon::Fields::ITEMS] || {}).map { |x| JSON.parse(x) }
      holdings = (self[TrlnArgon::Fields::HOLDINGS] || {}).map { |x| JSON.parse(x) }
      # { LOC_B => { LOC_N => [ items ] } }
      items_intermediate = Hash[items.group_by { |i| i['loc_b'] }.map do |loc_b, locations_narrow|
        [loc_b, locations_narrow.group_by { |i| i['loc_n'] }]
      end]

      h_final = Hash[items_intermediate.map do |loc_b, loc_map|
        [loc_b, Hash[loc_map.map do |loc_n, loc_items|
          h = {}

          h['items'] = loc_items.map do |i|
            i.reject { |k, _v| %w[loc_b loc_n].include?(k) }
          end

          h['holdings'] = select_matching_holdings(holdings, loc_b, loc_n)

          if h['holdings'].empty?
            h['holdings'] << { 'summary' => '', 'call_no' => cn_prefix(h['items']) }
          end

          [loc_n, h]
        end]]
      end]

      # finally, create holdings where we have summaries but no
      # items ... potentially controversial
      holdings.each do |h|
        loc_b = h['loc_b']
        loc_n = h['loc_n']
        loc_map = h_final[loc_b] ||= {}
        loc_map[loc_n] ||= { 'items' => [] }
        loc_map[loc_n]['holdings'] ||= select_matching_holdings(holdings, loc_b, loc_n)
      end

      h_final.reject { |k, v| k.nil? }
    end

    def select_matching_holdings(holdings, loc_b, loc_n)
      holdings.select { |hs| hs['loc_b'] == loc_b && hs['loc_n'] == loc_n }
              .map { |hs| hs.except('loc_b', 'loc_n') }
    end

    def cn_prefix(items)
      cns = items.reject(&:nil?).map do |i|
        if i.fetch('cn_scheme', '') == 'LC'
          i['call_no'].to_s.gsub(/\d{4}$/, '').strip
        else
          i['call_no'].to_s.strip
        end
      end
      cns.first
    end
  end
end
