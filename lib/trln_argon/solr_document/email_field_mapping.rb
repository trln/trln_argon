module TrlnArgon
  module SolrDocument
    module EmailFieldMapping
      # Override this method in local models/solr_document.rb
      # to set local Email field mappings.
      # By default it will fetch values from the specified Solr field.
      # (Use the Solr Field constants, e.g. TrlnArgon::Fields::FIELD_CONSTANT)
      # For more complex data mappings see proc examples.

      # rubocop:disable MethodLength
      # rubocop:disable AbcSize
      def email_field_mapping
        @email_field_mapping ||= {
          title: TrlnArgon::Fields::TITLE_MAIN,
          author: TrlnArgon::Fields::STATEMENT_OF_RESPONSIBILITY,
          link_to_record: proc do
                            TrlnArgon::Engine.configuration.root_url.chomp('/') +
                              Rails.application.routes.url_helpers.solr_document_path(self)
                          end,
          location: proc { holdings_to_text },
          publisher: proc { imprint_main_to_text },
          edition: TrlnArgon::Fields::EDITION,
          date: TrlnArgon::Fields::PUBLICATION_YEAR,
          format: TrlnArgon::Fields::RESOURCE_TYPE,
          # series:
          # description:
          # identifiers:
          # notes:
          # contents:
          # summary:
          full_text_link: proc { fulltext_urls.map { |u| u[:href] } },
          findingaid_link: proc { findingaid_urls.map { |u| u[:href] } }
        }
      end
    end
  end
end
