describe TrlnArgonHelper do

  describe '#entry_name' do

    context 'count is 1' do

      it 'should not pluralize the entry name' do
        expect(helper.entry_name(1)).to eq('result')
      end

    end

    context 'count is more than 1' do

      it 'should pluralize the entry name' do
        expect(helper.entry_name(2)).to eq('results')
      end

    end

  end

  describe '#institution_short_name' do

    it 'should use the configured and translated name' do
      expect(helper.institution_short_name).to eq('Duke')
    end

  end

  describe '#institution_long_name' do

    it 'should use the configured and translated name' do
      expect(helper.institution_long_name).to eq('Duke Libraries')
    end

  end

  describe '#consortium_short_name' do

    it 'should use the translated name' do
      expect(helper.consortium_short_name).to eq('TRLN')
    end

  end

  describe '#consortium_long_name' do

    it 'should use the translated name' do
      expect(helper.consortium_long_name).to eq('TRLN Libraries')
    end

  end

  describe '#filter_scope_name' do

    context 'scope is BookmarksController' do

      before { allow(helper).to receive(:controller_name) { 'bookmarks' } }

      it 'should use the translated scope name for bookmarks' do
        expect(helper.filter_scope_name).to eq('bookmarked')
      end

    end

    context 'local filter is applied', verify_stubs: false do

      before do
        allow(helper).to receive(:controller_name) { 'catalog' }
        allow(helper).to receive(:local_filter_applied?) { true }
      end

      it 'should use the translated scope name for bookmarks' do
        expect(helper.filter_scope_name).to eq('Duke')
      end

    end

    context 'local filter is not applied', verify_stubs: false do

      before do
        allow(helper).to receive(:controller_name) { 'catalog' }
        allow(helper).to receive(:local_filter_applied?) { false }
      end

      it 'should use the translated scope name for bookmarks' do
        expect(helper.filter_scope_name).to eq('TRLN')
      end

    end

  end

end
