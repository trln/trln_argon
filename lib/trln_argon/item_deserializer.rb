# Mixin for SolrDocument to allow deserializing item information
# to a userful structure
module TrlnArgon
  module ItemDeserializer
    include ActionView::Helpers::TextHelper
    def deserialize
      (self[TrlnArgon::Fields::ITEMS] || ['{}']).map { |d| JSON.parse(d) }
                                                .group_by { |rec| rec['loc_b'] }
    end

    def read_items
      @read_items ||= deserialize
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
          h = holdings.find { |i| i['loc_b'] == loc_b && i['loc_n'] == loc_n } ||
              { 'summary' => '', 'call_no' => '', 'notes' => [] }
          h['items'] = loc_items.map do |i|
            i.reject { |k, _v| %w[loc_b loc_n].include?(k) }
          end
          h['summary'] ||= ''
          h['call_no'] = cn_prefix(h['items'])
          [loc_n, h]
        end]]
      end]

      # finally, create holdings where we have summaries but no
      # items ... potentially controversial
      holdings.each do |h|
        loc_b = h['loc_b']
        loc_n = h['loc_n']
        loc_map = h_final[loc_b] ||= {}
        loc_map[loc_n] ||= h.update('items' => [])
      end
      h_final.reject { |k, v| k.nil? }
    end

    # For RIS, Email and other record export functions
    def holdings_to_text
      @holdings_to_text ||= holdings.flat_map do |loc_b, loc_n_map|
        loc_n_map.map do |_loc_n, items|
          I18n.t('trln_argon.item_location',
                 loc_b_display: TrlnArgon::LookupManager.instance.map("#{self.record_owner}.loc_b.#{loc_b}"),
                 call_number: items['call_no'].strip)
        end
      end
    end

    def holdings
      @holdings ||= deserialize_holdings
    end

    def cn_prefix(items)
      cns = items.reject(&:nil?).map { |i| i['call_no'].to_s.gsub(/\d{4}$/, '') }
      cns[0]
    end
  end
end
