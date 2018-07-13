describe TrlnArgon::ViewHelpers::SearchScopeToggleHelper, type: :helper do
  describe '#query_state_from_search_state' do
    let(:query_params) { { controller: 'catalog', action: 'index', q: 'ecology without nature' } }
    let(:config) { Blacklight::Configuration.new }
    let(:search_state) { Blacklight::SearchState.new(query_params, config, controller) }

    it 'returns the query paramters without controller or action keys' do
      expect(helper.query_state_from_search_state(search_state)).to eq(
        'q' => 'ecology without nature'
      )
    end
  end

  describe '#local_search_button_class' do
    context 'when local filter is applied to search' do
      it 'returns the expected class' do
        allow(helper).to receive(:local_filter_applied?).and_return(true)
        expect(helper.local_search_button_class).to eq('btn-primary')
      end
    end

    context 'when local filter is NOT applied to search' do
      it 'returns the expected class' do
        allow(helper).to receive(:local_filter_applied?).and_return(false)
        expect(helper.local_search_button_class).to eq('btn-default')
      end
    end
  end

  describe '#trln_search_button_class' do
    context 'when local filter is applied to search' do
      it 'returns the expected class' do
        allow(helper).to receive(:local_filter_applied?).and_return(true)
        expect(helper.trln_search_button_class).to eq('btn-default')
      end
    end

    context 'when local filter is NOT applied to search' do
      it 'returns the expected class' do
        allow(helper).to receive(:local_filter_applied?).and_return(false)
        expect(helper.trln_search_button_class).to eq('btn-primary')
      end
    end
  end

  # rubocop:disable VerifiedDoubles
  describe '#no_results_escape_href_url' do
    let(:search_trln_path) { double('search_trln_path') }

    context 'local filter is NOT applied' do
      it 'receives the search_trln_path' do
        allow(helper).to receive(:local_filter_applied?).and_return(false)
        expect(helper).to receive(:search_trln_path)
        helper.no_results_escape_href_url
      end
    end
  end
end
