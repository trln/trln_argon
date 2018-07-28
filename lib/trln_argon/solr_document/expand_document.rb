module TrlnArgon
  module SolrDocument
    module ExpandDocument
      def docs_with_merged_holdings
        array = []
        docs_grouped_by_association.each do |_, docs|
          rolled_up_record = docs.first.dup.to_h
          rolled_up_record[TrlnArgon::Fields::ITEMS] = docs.flat_map { |d| d[TrlnArgon::Fields::ITEMS] }.compact
          rolled_up_record[TrlnArgon::Fields::HOLDINGS] = docs.flat_map { |d| d[TrlnArgon::Fields::HOLDINGS] }.compact
          rolled_up_record[TrlnArgon::Fields::URLS] = docs.flat_map { |d| d[TrlnArgon::Fields::URLS] }.compact
          array << ::SolrDocument.new(rolled_up_record)
        end
        array
      end

      def docs_grouped_by_association
        @docs_grouped_by_association ||= expanded_documents.group_by(&:record_association)
      end

      def expanded_documents
        @expanded_documents ||= expanded_docs_search.documents.present? ? expanded_docs_search.documents : [self]
      end

      private

      def expanded_docs_search
        @expanded_docs_search ||= begin
          controller = CatalogController.new
          search_builder = SearchBuilder.new([:add_query_to_solr], controller)
          query = search_builder.where("#{TrlnArgon::Fields::ROLLUP_ID}:#{self[TrlnArgon::Fields::ROLLUP_ID]}")
                                .merge(rows: 100)
          controller.repository.search(query)
        end
      end
    end
  end
end
