describe User do
  subject(:user) { described_class.create! email: 'xyz@example.com', password: 'xyz12345' }

  def mock_bookmark(document_id)
    Bookmark.new document_id: document_id, document_type: SolrDocument.to_s
  end

  describe '#bookmarks_for_documents' do
    before do
      user.bookmarks << mock_bookmark(1)
      user.bookmarks << mock_bookmark(2)
      user.bookmarks << mock_bookmark(3)
    end

    let(:bookmarks) do
      user.bookmarks_for_documents([SolrDocument.new(id: 1), SolrDocument.new(id: 2)])
    end

    it 'returns all the bookmarks that match the given documents' do
      expect(bookmarks.count).to eq 2
    end

    it 'the first bookmark has the correct document ID' do
      expect(bookmarks.first.document_id).to eq '1'
    end

    it 'the second bookmark has the correct document ID' do
      expect(bookmarks.last.document_id).to eq '2'
    end
  end
end
