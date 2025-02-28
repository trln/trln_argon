module TrlnArgon
  module ViewHelpers
    module DocumentExportHelper
      # the various `solr_document__url|path` identifiers
      # below are dynamically created methods in
      # ActionDispatch::Routing::RouteSet (rails 7.1)
      # _options hashes are ignored because the framework will
      # populate the URL with extraneous parameters; if necessary,
      # these can be restored but if so, filter out any `id`
      # parameters
      #
      # however, in the test environment we need to pass in the id param

      def refworks_path(options = {})
        "#{TrlnArgon::Engine.configuration.refworks_url}#{ris_url(options)}"
      end

      def ris_path(options = {})
        fmt = { format: :ris }
        return solr_document_path(fmt.merge(options)) if Rails.env.test?

        solr_document_path(fmt)
      end

      def ris_url(options = {})
        fmt = { format: :ris }
        # this only breaks under test, but not in productiondd
        return solr_document_url(fmt.merge(options)) if Rails.env.test?

        solr_document_url(fmt)
      end

      def email_path(_options = {})
        email_solr_document_path
      end

      def email_url(_options = {})
        email_solr_document_url
      end

      def sms_path(_options = {})
        sms_solr_document_path
      end

      def sms_url(_options = {})
        sms_solr_document_url
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
