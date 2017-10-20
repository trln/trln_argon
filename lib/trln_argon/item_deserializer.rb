# Mixin for SolrDocument to allow deserializing item information
# to a userful structure
module TrlnArgon
  module ItemDeserializer
    include ActionView::Helpers::TextHelper
    def deserialize
      (self[TrlnArgon::Fields::ITEMS] || ['{}']).map { |d| stringified_hash_to_json(d) }
                                                .group_by { |rec| rec['library'] }
    end

    def read_items
      @read_items ||= deserialize
    end

    def deserialize_holdings
      items = (self[TrlnArgon::Fields::ITEMS] || {}).map { |x| stringified_hash_to_json(x) }
      holdings = (self[TrlnArgon::Fields::HOLDINGS] || {}).map { |x| stringified_hash_to_json(x) }
      # { LIBRARY => { LOCATION => [ items ] } }
      items_intermediate = Hash[items.group_by { |i| i['library'] }.map do |lib, locations|
        [lib, locations.group_by { |i| i['shelving_location'] }]
      end]

      h_final = Hash[items_intermediate.map do |lib, loc_map|
        [lib, Hash[loc_map.map do |loc, loc_items|
          h = holdings.find { |i| i['library'] == lib && i['location'] == loc } ||
              { 'summary' => '', 'call_number' => '', 'notes' => [] }
          h['items'] = loc_items.collect do |i|
            i.reject { |k, _v| %w[library shelving_location].include?(k) }
          end
          h['call_number'] = cn_prefix(h['items'])
          if h['summary'].blank?
            items = h['items'] || []
            avail = items.count { |i| 'available' == i['status'].downcase rescue false }
            sum = "(#{pluralize(items.count, 'copy')}"
            sum << ", #{avail} available" unless avail == items.count		
            sum << ")"
            h['summary'] = sum
          end
          [loc, h]
        end]]
      end]

      # finally, create holdings where we have summaries but no
      # items ... potentially controversial
      holdings.each do |h|
        lib = h['library']
        loc = h['location']
        loc_map = h_final[lib] ||= {}
        loc_map[loc] ||= h.update('items' => [])
      end
      h_final.reject { |k, v| k.nil? }
    end

    def holdings
      @holdings ||= deserialize_holdings
    end

    def cn_prefix(items)
      cns = items.reject(&:nil?).collect { |i| i['call_number'].to_s.gsub(/\d{4}$/, '') }
      cns[0]
    end

    def stringified_hash_to_json(x)
      JSON.parse(x.gsub('=>', ':'))
    end

     # quick hack, for the moment: we need to guess the context for looking up
    # location and status codes when displaying items, and the items themselves
    # don't contain this data.
    def record_owner
      self[TrlnArgon::Fields::INSTITUTION].first
    end
  end
end
