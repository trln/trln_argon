module TrlnArgon
  # The DocumentExtensions module contains document extensions
  # added as extensions to the host application's SolrDocument class.
  # e.g. SolrDocument.use_extension(TrlnArgon::DocumentExtensions::Ris)
  module DocumentExtensions
    autoload :Email, 'trln_argon/document_extensions/email'
    autoload :Ris, 'trln_argon/document_extensions/ris'
    autoload :Sms, 'trln_argon/document_extensions/sms'
  end
end
