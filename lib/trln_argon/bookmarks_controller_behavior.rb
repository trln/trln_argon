module TrlnArgon
  module BookmarksControllerBehavior
    extend ActiveSupport::Concern

    included do
      helper_method :ris_path
      helper_method :ris_url
      helper_method :email_path
      helper_method :email_url
      helper_method :sms_path
      helper_method :sms_url
      helper_method :url_for_document

      configure_blacklight do |config|
        config.search_builder_class = RollupOnlySearchBuilder
      end

      private

      def url_for_document(doc, options = {})
        return unless doc.respond_to?(:id)
        trln_solr_document_url(doc, options)
      end

      def filter_scope_name
        t('trln_argon.scope_name.bookmarks')
      end

      def ris_path(options = {})
        bookmarks_path({ format: :ris }.merge(options))
      end

      def ris_url(options = {})
        bookmarks_url({ format: :ris }.merge(options))
      end

      def email_path(options = {})
        email_bookmarks_path(options)
      end

      def email_url(options = {})
        email_bookmarks_url(options)
      end

      def sms_path(options = {})
        sms_bookmarks_path(options)
      end

      def sms_url(options = {})
        sms_bookmarks_url(options)
      end
    end
  end
end