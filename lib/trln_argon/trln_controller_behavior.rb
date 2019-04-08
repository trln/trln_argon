module TrlnArgon
  module TrlnControllerBehavior
    extend ActiveSupport::Concern

    included do
      helper_method :advanced_search_url
      helper_method :local_search_button_class
      helper_method :trln_search_button_class
      helper_method :local_search_button_label_class
      helper_method :trln_search_button_label_class
      helper_method :no_results_escape_href_url
      helper_method :filter_scope_name
      helper_method :url_for_document
      helper_method :ris_path
      helper_method :ris_url
      helper_method :show_solr_document_path
      helper_method :show_solr_document_url
      helper_method :email_path
      helper_method :email_url
      helper_method :sms_path
      helper_method :sms_url

      configure_blacklight do |config|
        config.search_builder_class = DefaultTrlnSearchBuilder

        config.show.route = { controller: :trln }

        # These params are added to the Solr document request to fetch any
        # associated rolled up documents so that holdings, items,
        # and links can be shown for all associated records in the
        # expanded TRLN context.
        config.default_document_solr_params = {
          :expand => 'true',
          'expand.field' => TrlnArgon::Fields::ROLLUP_ID,
          'expand.q' => '*:*',
          'expand.rows' => 50
        }
      end

      private

      def url_for_document(doc, options = {})
        search_state.url_for_document(doc, options)
      end

      def show_solr_document_path(doc, options = {})
        return unless doc.respond_to?(:id)
        trln_solr_document_path(options.merge(id: doc.id))
      end

      def show_solr_document_url(doc, options = {})
        return unless doc.respond_to?(:id)
        trln_solr_document_url(options.merge(id: doc.id))
      end

      def filter_scope_name
        t('trln_argon.consortium.short_name')
      end

      def advanced_search_url(options = {})
        trln_argon.url_for(options.merge(controller: 'advanced_trln', action: 'index'))
      end

      def local_search_button_class
        'btn-default'
      end

      def trln_search_button_class
        'btn-primary active'
      end

      def local_search_button_label_class
        ''
      end

      def trln_search_button_label_class
        'active'
      end

      def no_results_escape_href_url
        search_trln_path
      end

      def local_filter_search_builder
        LocalOnlySearchBuilder.new(CatalogController)
      end

      def ris_path(options = {})
        trln_solr_document_path({ format: :ris }.merge(options))
      end

      def ris_url(options = {})
        trln_solr_document_url({ format: :ris }.merge(options))
      end

      def email_path(options = {})
        email_trln_solr_document_path(options)
      end

      def email_url(options = {})
        email_trln_solr_document_url(options)
      end

      def sms_path(options = {})
        sms_trln_solr_document_path(options)
      end

      def sms_url(options = {})
        sms_trln_solr_document_url(options)
      end
    end
  end
end
