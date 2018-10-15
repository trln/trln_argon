require 'trln_argon/solr_document/email_field_mapping'
require 'trln_argon/solr_document/expand_document'
require 'trln_argon/solr_document/field_deserializer'
require 'trln_argon/solr_document/imprint'
require 'trln_argon/solr_document/openurl_ctx_kev_field_mapping'
require 'trln_argon/solr_document/ris_field_mapping'
require 'trln_argon/solr_document/sms_field_mapping'
require 'trln_argon/solr_document/urls'
require 'trln_argon/solr_document/work_entry'

module TrlnArgon
  # Mixin for SolrDocument with TRLN Argon Specific Behavior
  module SolrDocument
    include EmailFieldMapping
    include ExpandDocument
    include FieldDeserializer
    include Imprint
    include OpenurlCtxKevFieldMapping
    include RisFieldMapping
    include SmsFieldMapping
    include Urls
    include WorkEntry

    def availability
      if self[TrlnArgon::Fields::AVAILABLE].present?
        I18n.t('trln_argon.availability.available')
      else
        I18n.t('trln_argon.availability.not_available')
      end
    end

    # Organizational association for the record.
    # Expected to be one of: duke, unc, ncsu, nccu, trln
    # Used to group records for display purposes, especially
    # needed for the case of shared records where the association
    # is 'trln' but the record owner may be 'unc' (or 'duke', etc.)
    def record_association
      case fetch(TrlnArgon::Fields::INSTITUTION, []).count
      when 0, 1
        record_owner
      else
        'trln'
      end
    end

    # Institution that is responsible for the record
    # Used to lookup location codes.
    # Expected to be one of: duke, unc, ncsu, nccu
    def record_owner
      fetch(TrlnArgon::Fields::OWNER, []).first.to_s.downcase
    end

    def isbn_with_qualifying_info
      @isbn_with_qualifying_info ||=
        [*self[TrlnArgon::Fields::ISBN_NUMBER]].zip(
          [*self[TrlnArgon::Fields::ISBN_QUALIFYING_INFO]]
        ).map { |isbn_info_pairs| isbn_info_pairs.join(' ') }
    end

    def names
      @names ||= deserialize_solr_field(TrlnArgon::Fields::NAMES, name: '', rel: '')
    end

    def marc_summary
      format_for_display(self[TrlnArgon::Fields::NOTE_SUMMARY])
    end

    def marc_toc
      format_for_display(self[TrlnArgon::Fields::NOTE_TOC])
    end

    def statement_of_responsibility
      [*self[TrlnArgon::Fields::STATEMENT_OF_RESPONSIBILITY_VERN]].concat(
        [*self[TrlnArgon::Fields::STATEMENT_OF_RESPONSIBILITY]]
      ).join(' / ')
    end

    def isbn_number
      fetch(TrlnArgon::Fields::ISBN_NUMBER, [])
    end

    def oclc_number
      fetch(TrlnArgon::Fields::OCLC_NUMBER, '')
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
