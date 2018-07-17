describe TrlnArgon::TrlnControllerBehavior do
  class TrlnControllerBehaviorTestClass < TrlnController
  end

  let(:mock_controller) { TrlnControllerBehaviorTestClass.new }
  let(:override_config) { mock_controller.blacklight_config }

  describe 'search builder' do
    it 'uses the expected search builder' do
      expect(override_config.search_builder_class).to eq(DefaultTrlnSearchBuilder)
    end
  end

  describe '#filter_scope_name' do
    it 'sets the name to TRLN' do
      expect(mock_controller.helpers.filter_scope_name).to eq('TRLN')
    end
  end

  describe '#local_search_button_class' do
    it 'sets the search button class' do
      expect(mock_controller.helpers.local_search_button_class).to eq(
        'btn-default'
      )
    end
  end

  describe '#trln_search_button_class' do
    it 'sets the TRLN search button class' do
      expect(mock_controller.helpers.trln_search_button_class).to eq(
        'btn-primary active'
      )
    end
  end

  describe '#local_search_button_label_class' do
    it 'sets the search button label class' do
      expect(mock_controller.helpers.local_search_button_label_class).to eq('')
    end
  end

  describe '#trln_search_button_label_class' do
    it 'sets the TRLN search button label class' do
      expect(mock_controller.helpers.trln_search_button_label_class).to eq('active')
    end
  end
end
