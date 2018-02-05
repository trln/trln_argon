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
          publisher: proc { imprint_main_to_text },
          date: TrlnArgon::Fields::PUBLICATION_YEAR_SORT,
          format: TrlnArgon::Fields::FORMAT,
          # series:
          subject: TrlnArgon::Fields::SUBJECTS,
          # description:
          # identifiers:
          # notes:
          # contents:
          # summary:
          location: proc { expanded_holdings_to_text },
          full_text_link: proc { fulltext_urls.map { |u| u[:href] } },
          findingaid_link: proc { findingaid_urls.map { |u| u[:href] } },
          link_to_record: proc do
                            TrlnArgon::Engine.configuration.root_url.chomp('/') +
                              Rails.application.routes.url_helpers.solr_document_path(self)
                          end
        }
      end
    end
  end
end
