module TrlnArgon
  module SolrDocument
    module ExpandDocument
      def expanded_holdings_to_text
        @expanded_holdings_to_text ||= expanded_holdings.flat_map do |inst, loc_b_map|
          loc_b_map.flat_map do |loc_b, loc_n_map|
            loc_n_map.map do |_loc_n, items|
              I18n.t('trln_argon.item_location',
                     inst_display: I18n.t("trln_argon.institution.#{inst}.short_name"),
                     loc_b_display: TrlnArgon::LookupManager.instance.map("#{inst}.loc_b.#{loc_b}"),
                     call_number: items['call_no'].strip)
            end
          end
        end
      end

      def expanded_holdings
        @expanded_holdings ||= Hash[expanded_documents.map do |doc|
          [doc.institution,
           doc.holdings]
        end]
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
          controller.repository.search(query)
        end
      end
    end
  end
end
