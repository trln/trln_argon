module TrlnArgon
  module User
    def bookmarks_for_documents(documents = [])
      if documents.any?
        bookmarks.where(document_id: documents.map(&:id))
      else
        []
      end
    end
  end
end
