class TrlnController < CatalogController
  include TrlnArgon::TrlnControllerBehavior

  configure_blacklight do |config|
    config.document_model = TrlnSolrDocument
  end
end
