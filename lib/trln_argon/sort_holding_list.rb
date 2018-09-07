module TrlnArgon
  module SortHoldingList
    def self.by_institution(docs_grouped_by_association)
      sorted_docs = {}
      sort_order = TrlnArgon::Engine.configuration.sort_order_in_holding_list.split(', ')
      sort_order.each do |university|
        docs_grouped_by_association.each do |institution, doc|
          sorted_docs[institution] = doc if institution == university
        end
      end
      sorted_docs
    end
  end
end
