module TrlnArgon
  module SolrDocument
    module ExpandDocument
      # NOTE: This array of pseudo-documents is generated to account
      #       for cases where multiple records from a single institution
      #       get rolled up together. So that holdings/items can be displayed
      #       normally without repeated locations we merge the data from multiple
      #       rolled up records into a single psuedo-document per institution.
      def docs_with_holdings_merged_from_expanded_docs
        @docs_with_holdings_merged_from_expanded_docs ||=
          expanded_docs_grouped_by_association.map do |_, docs|
            rec = docs.first.dup.to_h
            flat_map_field_values(rec, docs, TrlnArgon::Fields::ITEMS)
            flat_map_field_values(rec, docs, TrlnArgon::Fields::HOLDINGS)
            flat_map_field_values(rec, docs, TrlnArgon::Fields::URLS)
            if docs.map { |d| d[TrlnArgon::Fields::AVAILABLE] }.include?('Available')
              rec[TrlnArgon::Fields::AVAILABLE] = 'Available'
            end
            ::SolrDocument.new(rec)
          end
      end

      def expanded_docs_grouped_by_association
        @expanded_docs_grouped_by_association ||=
          sort_by_configured_record_association_order(
            expanded_docs.group_by(&:record_association)
          )
      end

      def expanded_docs
        @expanded_docs ||= (response.try(:[], 'expanded')
                                    .try(:[], self[TrlnArgon::Fields::ROLLUP_ID])
                                    .try(:[], 'docs') || [])
                           .map { |doc| ::SolrDocument.new(doc) } << self
      end

      private

      def sort_by_configured_record_association_order(docs_grouped_by_association)
        docs_grouped_by_association.sort_by do |key, _|
          configured_association_sort_order.index(key)
        end.to_h
      end

      def configured_association_sort_order
        TrlnArgon::Engine.configuration.sort_order_in_holding_list.split(', ')
      end

      def flat_map_field_values(rec, docs, field)
        rec[field] = docs.flat_map { |d| d[field] }.compact
      end
    end
  end
end
