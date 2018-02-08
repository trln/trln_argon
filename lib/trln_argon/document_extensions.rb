module TrlnArgon
  # The DocumentExtensions module contains document extensions
  # added as extensions to the host application's SolrDocument class.
  # e.g. SolrDocument.use_extension(TrlnArgon::DocumentExtensions::OpenurlCtxKev)
  module DocumentExtensions
    autoload :Email, 'trln_argon/document_extensions/email'
    autoload :OpenurlCtxKev, 'trln_argon/document_extensions/openurl_ctx_kev'
    autoload :Ris, 'trln_argon/document_extensions/ris'
  end
end
