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
            proc { 'info:sid/discovery.trln.org/catalog' }
          ],
          metadata: {
            au: TrlnArgon::Fields::STATEMENT_OF_RESPONSIBILITY,
            btitle: TrlnArgon::Fields::TITLE_MAIN,
            date: TrlnArgon::Fields::PUBLICATION_YEAR,
            edition: TrlnArgon::Fields::EDITION,
            # genre: , TODO
            isbn: TrlnArgon::Fields::ISBN_NUMBER,
            # issn: , TODO
            # place: , TODO
            # pub: , TODO
            # series: , TODO
            title: TrlnArgon::Fields::TITLE_MAIN
          }
        }
      end
    end
  end
end
