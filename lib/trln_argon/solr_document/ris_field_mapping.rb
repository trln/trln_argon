module TrlnArgon
  module SolrDocument
    module RisFieldMapping
      # Override this method in local models/solr_document.rb
      # to set local RIS field mappings.
      # By default it will fetch values from the specified Solr field.
      # (Use the Solr Field constants, e.g. TrlnArgon::Fields::FIELD_CONSTANT)
      # For more complex data mappings see proc examples.

      # rubocop:disable MethodLength
      # rubocop:disable AbcSize
      def ris_field_mapping
        @ris_field_mapping ||= {
          # Type of reference
          TY: proc { ris_type([*self[TrlnArgon::Fields::RESOURCE_TYPE]]) },
          # First Author
          A1: TrlnArgon::Fields::STATEMENT_OF_RESPONSIBILITY,
          # Second Author
          # A2: ,
          # Location in Archives (Inst., Lib., Call No.)
          AV: proc { holdings_to_text },
          # Place Published (Note: Combined with Publisher in Argon imprint_main)
          # CY: ,
          # Reference ID
          ID: TrlnArgon::Fields::ID,
          # Keywords (Subjects)
          KW: TrlnArgon::Fields::SUBJECT_HEADINGS,
          # Link to Full-text (TODO: Include findingaid URLs?)
          L2: proc { fulltext_urls.map { |v| v[:href] } },
          # Language
          LA: TrlnArgon::Fields::LANGUAGE,
          # Miscellaneous 2 (TODO: UPC, OCLC, Pub Number, etc.)
          # M2: ,
          # Type of Work (TODO: Looks like TOC? Summary?)
          # M3: ,
          # Notes
          N1: TrlnArgon::Fields::NOTE_GENERAL,
          # Publisher (Note: Combined with Place Published in Argon imprint_main)
          PB:  proc { imprint_main_to_text },
          # Publication year (YYYY/MM/DD)
          PY: TrlnArgon::Fields::PUBLICATION_YEAR_SORT,
          # ISBN/ISSN
          # SN: ,
          # Primary Title
          TI: TrlnArgon::Fields::TITLE_MAIN,
          # Secondary Title (journal title, if applicable)
          # T2: ,
          # URL
          UR: proc do
                TrlnArgon::Engine.configuration.root_url.chomp('/') +
                  Rails.application.routes.url_helpers.solr_document_path(self)
              end
        }
      end

      # rubocop:disable CyclomaticComplexity
      def ris_type(resource_type)
        case resource_type.first
        when 'Archival and manuscript material'
          'MANSCPT'
        when 'Audiobook'
          'SOUND'
        when 'Book'
          'BOOK'
        when 'Database'
          'DBASE'
        when 'Dataset -- Statistical'
          'DATA'
        when 'Dataset -- Geospatial'
          'DATA'
        when 'Game'
          'GEN'
        when 'Government publication'
          'GOVDOC'
        when 'Image'
          'GEN'
        when 'Journal, Magazine, or Periodical'
          'SER'
        when 'Kit'
          'GEN'
        when 'Map'
          'MAP'
        when 'Music recording'
          'SOUND'
        when 'Music score'
          'MUSIC'
        when 'Newspaper'
          'NEWS'
        when 'Non-musical sound recording'
          'SOUND'
        when 'Object'
          'GEN'
        when 'Software/multimedia'
          'COMP'
        when 'Thesis/Dissertation'
          'THES'
        when 'Video'
          'VIDEO'
        when 'Web page or site'
          'ELEC'
        else
          'GEN'
        end
      end
    end
  end
end
