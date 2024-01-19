require 'trln_argon/solr_document/citation'
require 'trln_argon/solr_document/email_field_mapping'
require 'trln_argon/solr_document/expand_document'
require 'trln_argon/solr_document/field_deserializer'
require 'trln_argon/solr_document/imprint'
require 'trln_argon/solr_document/openurl_ctx_kev_field_mapping'
require 'trln_argon/solr_document/ris_field_mapping'
require 'trln_argon/solr_document/sms_field_mapping'
require 'trln_argon/solr_document/syndetics_data'
require 'trln_argon/solr_document/urls'
require 'trln_argon/solr_document/work_entry'
require 'trln_argon/solr_document/highwire_field_mapping'

module TrlnArgon
  # Mixin for SolrDocument with TRLN Argon Specific Behavior
  # rubocop:disable ModuleLength
  module SolrDocument
    include Citation
    include EmailFieldMapping
    include ExpandDocument
    include FieldDeserializer
    include Imprint
    include OpenurlCtxKevFieldMapping
    include RisFieldMapping
    include SmsFieldMapping
    include SyndeticsData
    include Urls
    include WorkEntry
    include HighwireFieldMapping

    def availability
      if self[TrlnArgon::Fields::AVAILABLE].present?
        I18n.t('trln_argon.availability.available')
      else
        I18n.t('trln_argon.availability.not_available')
      end
    end

    def edition
      [*self[TrlnArgon::Fields::EDITION]].reverse.join(' / ')
    end

    def genre_headings
      [*self[TrlnArgon::Fields::GENRE_HEADINGS]].concat(
        [*self[TrlnArgon::Fields::GENRE_HEADINGS_VERN]]
      )
    end

    def internet_archive_id
      fetch(TrlnArgon::Fields::INTERNET_ARCHIVE_ID, [])
    end

    def isbn_number
      fetch(TrlnArgon::Fields::ISBN_NUMBER, [])
    end

    def primary_isbn
      fetch(TrlnArgon::Fields::PRIMARY_ISBN, [])
    end

    def isbn_with_qualifying_info
      @isbn_with_qualifying_info ||=
        [*self[TrlnArgon::Fields::ISBN_NUMBER]].zip(
          [*self[TrlnArgon::Fields::ISBN_QUALIFYING_INFO]]
        ).map { |isbn_info_pairs| isbn_info_pairs.join(' ') }
    end

    # Needed so that document export functions can generate a link
    # back to the record without the controller context.
    def link_to_record
      TrlnArgon::Engine.configuration.root_url.chomp('/') +
        Rails.application.routes.url_helpers.solr_document_path(self)
    end

    def marc_summary
      format_for_display(self[TrlnArgon::Fields::NOTE_SUMMARY])
    end

    def marc_toc
      format_for_display(self[TrlnArgon::Fields::NOTE_TOC])
    end

    def names
      @names ||= deserialize_solr_field(TrlnArgon::Fields::NAMES,
                                        name: '',
                                        rel: '',
                                        type: '')
    end

    def names_to_text
      names.map { |n| n[:name] }.reject(&:empty?)
    end

    def creators_to_text
      names.select { |n| n[:type] == 'creator' || n[:type] == 'director' || n[:type] == 'no_rel' || n[:type] == '' }
           .map { |n| n[:name] }.reject(&:empty?)
    end

    def editors_to_text
      names.select { |n| n[:type] == 'editor' }
           .map { |n| n[:name] }.reject(&:empty?)
    end

    def oclc_number
      fetch(TrlnArgon::Fields::OCLC_NUMBER, '')
    end

    def primary_oclc
      fetch(TrlnArgon::Fields::PRIMARY_OCLC, [])
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

    def statement_of_responsibility
      [*self[TrlnArgon::Fields::STATEMENT_OF_RESPONSIBILITY_VERN]].concat(
        [*self[TrlnArgon::Fields::STATEMENT_OF_RESPONSIBILITY]]
      ).join(' / ')
    end

    # For RSS feed.
    def title_and_responsibility
      [fetch(TrlnArgon::Fields::TITLE_MAIN, 'Title Unknown'),
       statement_of_responsibility].reject(&:empty?).join(' / ')
    end

    def subject_headings
      [*self[TrlnArgon::Fields::SUBJECT_HEADINGS]].concat(
        [*self[TrlnArgon::Fields::SUBJECT_HEADINGS_VERN]]
      )
    end

    def upc
      fetch(TrlnArgon::Fields::UPC, []).map do |upc|
        upc.to_s.gsub(/\D/, '')
      end.reject(&:empty?)
    end

    def primary_upc
      fetch(TrlnArgon::Fields::PRIMARY_UPC, []).map do |primary_upc|
        primary_upc.to_s.gsub(/\D/, '')
      end.reject(&:empty?)
    end

    def issn
      [fetch(TrlnArgon::Fields::ISSN_PRIMARY, []),
       fetch(TrlnArgon::Fields::ISSN_LINKING, []),
       fetch(TrlnArgon::Fields::ISSN_SERIES, [])].flatten.uniq
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
  # rubocop:enable ModuleLength
end
