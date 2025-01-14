# frozen_string_literal: true

describe CatalogHelper do
  describe '#bookmarked?' do
    let(:bookmark) { Bookmark.new document: bookmarked_document }
    let(:bookmarked_document) { SolrDocument.new(id: 'a') }

    before do
      allow(helper).to receive(:current_bookmarks).and_return([bookmark])
    end

    it 'is bookmarked if the document is in the bookmarks' do
      expect(helper.bookmarked?(bookmarked_document)).to be true
    end

    it 'is not bookmarked if the document is not in the bookmarks' do
      expect(helper.bookmarked?(SolrDocument.new(id: 'b'))).to be false
    end
  end
end
