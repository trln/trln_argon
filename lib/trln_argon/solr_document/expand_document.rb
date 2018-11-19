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

      # NOTE: This is used by the TRLN view to show ALL restricted fulltext URLs
      #       Both shared and local urls get combined and grouped by each inst.
      def all_shared_and_local_fulltext_urls_by_inst
        configured_association_sort_order.map do |inst|
          non_shared_docs_for_inst_with_urls = non_shared_docs_for_inst_with_urls(inst)
          shared_docs_for_inst_with_urls = shared_docs_for_inst_with_urls(inst)
          if non_shared_docs_for_inst_with_urls.any?
            [inst, non_shared_docs_for_inst_with_urls.first.fulltext_urls]
          elsif shared_docs_for_inst_with_urls.any?
            [inst, shared_docs_for_inst_with_urls.first.expanded_shared_fulltext_urls[inst]]
          end
        end.compact.to_h
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

      def shared_docs_for_inst_with_urls(inst)
        @shared_docs_for_inst_with_urls ||=
          docs_with_holdings_merged_from_expanded_docs.select { |doc| doc.record_association == 'trln' }
                                                      .select { |doc| local_expanded_urls?(doc, inst) }
      end

      def non_shared_docs_for_inst_with_urls(inst)
        docs_with_holdings_merged_from_expanded_docs.select { |doc| doc.record_association == inst }
                                                    .select { |doc| doc.fulltext_urls.any? }
      end

      def local_expanded_urls?(doc, inst)
        doc.expanded_shared_fulltext_urls.keys.include?(inst)
      end

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
