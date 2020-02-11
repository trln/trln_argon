module TrlnArgon
  module ViewHelpers
    module DebugInfoHelper
      def solr_query_request
        return unless display_debug_info?
        link_to I18n.t('trln_argon.debug_info.solr_query_request'),
                solr_query_request_url,
                class: 'catalog_solrRequestLink btn btn-warning btn-sm',
                id: 'solrRequestLink',
                target: '_blank'
      end

      def solr_document_request(options = {})
        return unless display_debug_info?
        content_tag :span, class: solr_debug_info_class do
          "#{options.fetch(:document, '')&.id}: #{document_debug_links(options)}".html_safe
        end
      end

      def relevance_score(options = {})
        return unless display_debug_info?
        content_tag :span, class: solr_debug_info_class do
          "#{I18n.t('trln_argon.debug_info.solr_document_score')}#{relevance_score_span(options)}".html_safe
        end
      end

      private

      def document_debug_links(options)
        content_tag :span, class: solr_debug_info_details_class do
          link_to_solr_document_response(options).html_safe
        end
      end

      def link_to_solr_document_response(options)
        solr_doc_url = "#{solr_document_request_url}#{options.fetch(:document, '')&.id}".html_safe
        link_to(I18n.t('trln_argon.debug_info.solr_document_request'), solr_doc_url, target: '_blank')
      end

      def relevance_score_span(options)
        content_tag :span, class: solr_debug_info_details_class do
          number_with_delimiter(options.fetch(:value, ['unknown']).first, delimiter: ',')
        end
      end

      def solr_document_request_url
        "#{[solr_url, solr_document_only_path].join('/')}?id="
      end

      def solr_query_request_url
        "#{[solr_url, solr_query_path].join('/')}?#{solr_query_params}"
      end

      def solr_url
        Blacklight.connection_config.fetch(:url, nil).chomp('/')
      end

      def solr_query_params
        @response.fetch('responseHeader', [])
                 .fetch('params', {})
                 .to_query
      end

      def solr_document_only_path
        blacklight_config.document_solr_path
      end

      def solr_query_path
        blacklight_config.solr_path
      end

      def solr_debug_info_class
        'solr-debug-info'
      end

      def solr_debug_info_details_class
        'solr-debug-info-details'
      end

      def display_debug_info?
        params.fetch(:debug, false) == 'true'
      end
    end
  end
end
