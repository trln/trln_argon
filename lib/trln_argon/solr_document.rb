# Mixin for SolrDocument with TRLN Argon Specific Behavior
module TrlnArgon
  module SolrDocument
    include TrlnArgon::Document::RisFieldMapping
    include TrlnArgon::Document::OpenurlCtxKevFieldMapping

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
      @urls ||= deserialize_solr_field(TrlnArgon::Fields::URLS,
                                       { href: '', type: '', text: '' },
                                       :href)
    end

    def imprint_main
      @imprint_main ||= deserialize_solr_field(TrlnArgon::Fields::IMPRINT_MAIN,
                                               { type: '', label: '', value: '' },
                                               :value)
    end

    def imprint_multiple
      @imprint_multiple ||= deserialize_solr_field(TrlnArgon::Fields::IMPRINT_MULTIPLE,
                                                   { type: '', label: '', value: '' },
                                                   :value)
    end

    private

    def deserialize_solr_field(solr_field, hash_spec = {}, required_key = nil)
      deserialized_fields = [*self[solr_field]].map do |serialized_value|
        deserialized_hash = begin
          JSON.parse(serialized_value.to_s)
        rescue JSON::ParserError
          {}
        end
        hash_spec.merge(deserialized_hash.symbolize_keys)
      end
      return deserialized_fields if required_key.nil?
      deserialized_fields.delete_if { |h| h[required_key].empty? }
    end

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
  end
end
