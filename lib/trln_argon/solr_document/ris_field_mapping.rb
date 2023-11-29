module TrlnArgon
  module SolrDocument
    module RisFieldMapping
      # Override this method in local models/solr_document.rb
      # to set local RIS field mappings.
      # By default it will fetch values from the specified Solr field.
      # (Use the Solr Field constants, e.g. TrlnArgon::Fields::FIELD_CONSTANT)
      # For more complex data mappings see proc examples.

      def ris_field_mapping
        @ris_field_mapping ||= {
          # Type of reference
          TY: proc { ris_type([*self[TrlnArgon::Fields::RESOURCE_TYPE]]) },
          # First Author
          A1: proc { creators_to_text },
          # Second Author
          # A2: proc { creators_to_text },
          # Location in Archives (Inst., Lib., Call No.)
          AV: proc { locations_to_text },
          # Call Number
          CN: proc { callnumbers_to_text },
          # Place Published
          CY: TrlnArgon::Fields::PUBLISHER_LOCATION,
          # Editor
          ED: proc { editors_to_text },
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
          PB: proc { publisher_name_text },

          # Publication year (YYYY/MM/DD)
          PY: TrlnArgon::Fields::PUBLICATION_YEAR,
          # ISBN/ISSN
          SN: proc { isbn_number } || proc { issn },
          # Primary Title
          TI: TrlnArgon::Fields::TITLE_MAIN,
          # Secondary Title (journal title, if applicable)
          # T2: ,
          # URL
          UR: proc { link_to_record }
        }
      end

      # rubocop:disable CyclomaticComplexity
      # rubocop:disable Metrics/MethodLength
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
      # rubocop:enable Metrics/MethodLength
    end

    def publisher_name_text
      fetch('publisher_a', []).first || ''
    end
  end
end
