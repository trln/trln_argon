module TrlnArgon
  module ViewHelpers
    module DocumentExportHelper
      # Refworks is broken and will not accept an HTTPS callback URL,
      # so we convert the RIS URL to HTTP for now.
      def refworks_path(options = {})
        ris_uri = URI.parse(ris_url(options))
        ris_uri.scheme = 'http'
        "#{TrlnArgon::Engine.configuration.refworks_url}#{ris_uri}"
      end

      def ris_path(options = {})
        solr_document_path({ format: :ris }.merge(options))
      end

      def ris_url(options = {})
        solr_document_url({ format: :ris }.merge(options))
      end

      def email_path(options = {})
        email_solr_document_path(options)
      end

      def email_url(options = {})
        email_solr_document_url(options)
      end

      def sms_path(options = {})
        sms_solr_document_path(options)
      end

      def sms_url(options = {})
        sms_solr_document_url(options)
      end

      def render_ris(documents)
        documents.map { |x| x.export_as(:ris) }.compact.join("\r\n")
      end
    end
  end
end
