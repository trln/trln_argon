module TrlnArgon
  # SolrDocument behaviors needed in the TRLN Controller Context
  module TrlnSolrDocument
    # Needed so that document export functions can generate a link
    # back to the record in the TRLN view without the controller context.
    def link_to_record
      TrlnArgon::Engine.configuration.root_url.chomp('/') +
        Rails.application.routes.url_helpers.trln_solr_document_path(self)
    end
  end
end
