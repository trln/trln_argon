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
    it 'returns the expected class' do
      expect(helper.local_search_button_class).to eq('active')
    end
  end

  describe '#trln_search_button_class' do
    it 'returns the expected class' do
      expect(helper.trln_search_button_class).to eq('')
    end
  end
end
