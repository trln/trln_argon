require 'rails_helper'

RSpec.describe BookmarksHelper, type: :helper do
  describe 'bookmark query generation' do
    it 'returns empty string if no bookmarks are present' do
      bookmarks = []
      expect(helper.bookmarks_query(bookmarks)).to eq('')
    end

    it 'returns bookmark query if a bookmark is present' do
      bookmarks = %w[UNCb11138369]
      expect(helper.bookmarks_query(bookmarks)).to eq('id:(UNCb11138369)')
    end

    it 'returns an OR seperated bookmark query if multiple bookmarks are present' do
      bookmarks = %w[UNCb11138369 UNCb9753415 UNCb10553096]
      expect(helper.bookmarks_query(bookmarks)).to eq('id:(UNCb11138369 OR UNCb9753415 OR UNCb10553096)')
    end
  end
end
