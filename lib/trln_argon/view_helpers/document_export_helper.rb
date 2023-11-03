module TrlnArgon
  module ViewHelpers
    module DocumentExportHelper
      def refworks_path(options = {})
        "#{TrlnArgon::Engine.configuration.refworks_url}#{ris_url(options)}"
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

      def sharebookmarks_path(_options)
        search_trln_path(doc_ids: bookmarks_share_ids)
      end
    end
  end
end
