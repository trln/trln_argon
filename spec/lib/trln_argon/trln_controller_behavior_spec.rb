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

  describe '#local_filter_applied?' do
    it 'returns false' do
      expect(mock_controller.local_filter_applied?).to be false
    end
  end
end
