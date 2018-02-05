module TrlnArgon
  module ViewHelpers
    module DocumentExportHelper
      def argon_refworks_path(options = {})
        "#{TrlnArgon::Engine.configuration.refworks_url}#{ris_url(options)}"
      end

      def ris_path(options = {})
        if controller_name == 'bookmarks'
          bookmarks_path({ format: :ris }.merge(options))
        else
          solr_document_path({ format: :ris }.merge(options))
        end
      end

      def ris_url(options = {})
        if controller_name == 'bookmarks'
          bookmarks_url({ format: :ris }.merge(options))
        else
          solr_document_url({ format: :ris }.merge(options))
        end
      end

      def render_ris(documents)
        documents.map { |x| x.export_as(:ris) }.compact.join("\r\n")
      end
    end
  end
end
