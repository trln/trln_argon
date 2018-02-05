module TrlnArgon
  module Document
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
          # Type of reference (TODO: Translate Argon format to RIS type code)
          TY: proc { ['GEN'] },
          # First Author
          A1: TrlnArgon::Fields::AUTHORS_MAIN,
          # Second Author
          A2: proc do
                fetch(TrlnArgon::Fields::AUTHORS_DIRECTOR, []).concat(
                  fetch(TrlnArgon::Fields::AUTHORS_OTHER, [])
                )
              end,
          # Location in Archives (Inst., Lib., Call No.)
          AV: proc { expanded_holdings_display },
          # Place Published (TODO: Combined with Publisher in Argon imprint_main)
          # CY: ,
          # Reference ID
          ID: TrlnArgon::Fields::ID,
          # Keywords (Subjects)
          KW: TrlnArgon::Fields::SUBJECTS,
          # Link to Full-text (TODO: Include findingaid URLs?)
          L2: proc { fulltext_urls.map { |v| v[:href] } },
          # Language
          LA: TrlnArgon::Fields::LANGUAGE,
          # Miscellaneous 2 (TODO: UPC, OCLC, Pub Number, etc.)
          # M2: ,
          # Type of Work (TODO: Looks like TOC? Summary?)
          # M3: ,
          # Notes
          N1: TrlnArgon::Fields::NOTES_INDEXED,
          # Publisher (TODO: Combined with Place Published in Argon imprint_main)
          # PB: # Publisher,
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
    end
  end
end
