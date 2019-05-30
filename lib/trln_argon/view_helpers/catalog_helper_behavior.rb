module TrlnArgon
  module ViewHelpers
    module CatalogHelperBehavior
      include Blacklight::CatalogHelperBehavior

      # Override of Blacklight method so that we only use
      # the document id to fetch bookmarks, not also the
      # document model which doesn't work correctly
      # (maybe a Blackligh bug?).
      def bookmarked?(document)
        current_bookmarks.any? { |x| x.document_id == document.id }
      end
    end
  end
end
