# Mixin for SolrDocument with TRLN Argon Specific Behavior
module TrlnArgon
  module SolrDocument
    TOC_ATTR = 'note_toc_a'.freeze
    SUMMARY_ATTR = 'note_summary_a'.freeze

    def expanded_documents
      @expanded_documents ||= expand_docs_search.documents.present? ? expand_docs_search.documents : [self]
    end

    def expanded_holdings
      @expanded_holdings ||= Hash[expanded_documents.map do |doc|
        [doc[TrlnArgon::Fields::INSTITUTION].first,
         doc.deserialize_holdings]
      end]
    end

    def availability
      if self[TrlnArgon::Fields::AVAILABLE].present?
        I18n.t('trln_argon.availability.available')
      else
        I18n.t('trln_argon.availability.not_available')
      end
    end

    def marc_summary
      format_for_display(self[SUMMARY_ATTR])
    end

    def marc_toc
      format_for_display(self[TOC_ATTR])
    end

    private

    # utility for formatting multi-valued fields
    # when you're not really sure what else to do
    # with them
    def format_for_display(strings)
      strings.map {|x| "<p>#{x}</p>" }.join("\n") unless strings.nil?
    end

    def expand_docs_search
      controller = CatalogController.new
      search_builder = SearchBuilder.new([:add_query_to_solr], controller)
      query = search_builder.where("#{TrlnArgon::Fields::ROLLUP_ID}:#{self[TrlnArgon::Fields::ROLLUP_ID]}")
      controller.repository.search(query)
    end
  end
end
