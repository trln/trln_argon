module TrlnArgon
  module SolrDocument
    module OpenurlCtxKevFieldMapping
      # Override this method in local models/solr_document.rb
      # to set local OpenURL ctx kev field mappings (for COinS).
      # By default it will fetch values from the specified Solr field.
      # (Use the Solr Field constants, e.g. TrlnArgon::Fields::FIELD_CONSTANT)
      # For more complex data mappings see proc examples.

      # rubocop:disable MethodLength
      def openurl_ctx_kev_field_mapping
        @openurl_ctx_kev_field_mapping ||= {
          # TODO: Do something sensible when format is more settled
          format: proc { 'book' },
          identifiers: [
            proc { link_to_record }
          ],
          metadata: {
            au: TrlnArgon::Fields::STATEMENT_OF_RESPONSIBILITY,
            btitle: TrlnArgon::Fields::TITLE_MAIN,
            date: TrlnArgon::Fields::PUBLICATION_YEAR,
            edition: TrlnArgon::Fields::EDITION,
            genre: proc { zotero_genre([*self[TrlnArgon::Fields::RESOURCE_TYPE]].first.to_s) },
            isbn: TrlnArgon::Fields::ISBN_NUMBER,
            # place: , TODO
            issn: TrlnArgon::Fields::ISSN_LINKING,
            pub: proc { imprint_main_to_text },
            series: TrlnArgon::Fields::SERIES_STATEMENT,
            title: TrlnArgon::Fields::TITLE_MAIN
          }
        }
      end

      def zotero_genre(genre)
        case genre
        when 'Journal, Magazine, or Periodical'
          'journal'
        else
          'book'
        end
      end
    end
  end
end
