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
         doc.holdings]
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

    def fulltext_urls
      urls.select { |url| url[:type] == 'fulltext' }
    end

    def findingaid_urls
      urls.select { |url| url[:type] == 'findingaid' }
    end

    def thumbnail_urls
      urls.select { |url| url[:type] == 'thumbnail' }
    end

    def secondary_urls
      related_urls.concat other_urls
    end

    def related_urls
      urls.select { |url| url[:type] == 'related' }
    end

    def other_urls
      urls.select { |url| url[:type] == 'other' }
    end

    def urls
      @urls ||= [*self[TrlnArgon::Fields::URLS]].map { |url| deserialize_url(url) }.delete_if { |h| h[:href].empty? }
    end

    private

    # utility for formatting multi-valued fields
    # when you're not really sure what else to do
    # with them
    def format_for_display(strings)
      strings.map { |x| "<p>#{x}</p>" }.join("\n") unless strings.nil?
    end

    def expand_docs_search
      controller = CatalogController.new
      search_builder = SearchBuilder.new([:add_query_to_solr], controller)
      query = search_builder.where("#{TrlnArgon::Fields::ROLLUP_ID}:#{self[TrlnArgon::Fields::ROLLUP_ID]}")
      controller.repository.search(query)
    end

    def deserialize_url(serialized_url)
      url_hash = begin
        JSON.parse(serialized_url.to_s)
      rescue JSON::ParserError
        {}
      end
      { href: '', type: '', text: '' }.merge(url_hash.symbolize_keys)
    end
  end
end
