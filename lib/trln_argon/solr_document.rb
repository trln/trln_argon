require 'trln_argon/solr_document/email_field_mapping'
require 'trln_argon/solr_document/expand_document'
require 'trln_argon/solr_document/field_deserializer'
require 'trln_argon/solr_document/imprint'
require 'trln_argon/solr_document/openurl_ctx_kev_field_mapping'
require 'trln_argon/solr_document/ris_field_mapping'
require 'trln_argon/solr_document/urls'

module TrlnArgon
  # Mixin for SolrDocument with TRLN Argon Specific Behavior
  module SolrDocument
    include EmailFieldMapping
    include ExpandDocument
    include FieldDeserializer
    include Imprint
    include OpenurlCtxKevFieldMapping
    include RisFieldMapping
    include Urls

    def availability
      if self[TrlnArgon::Fields::AVAILABLE].present?
        I18n.t('trln_argon.availability.available')
      else
        I18n.t('trln_argon.availability.not_available')
      end
    end

    def marc_summary
      format_for_display(self[TrlnArgon::Fields::NOTE_SUMMARY])
    end

    def marc_toc
      format_for_display(self[TrlnArgon::Fields::NOTE_TOC])
    end

    private

    # utility for formatting multi-valued fields
    # when you're not really sure what else to do
    # with them
    def format_for_display(strings)
      strings.map { |x| "<p>#{x}</p>" }.join("\n") unless strings.nil?
    end

    # used primarily by document extensions for fetching values
    # in field mappings where the mapped value is either a
    # SolrDocument field or a proc.
    def call_or_fetch_value(value)
      value.respond_to?(:call) ? value.call : fetch(value, '')
    end
  end
end
