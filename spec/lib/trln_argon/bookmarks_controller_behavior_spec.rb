describe TrlnArgon::BookmarksControllerBehavior do
  class BookmarksControllerBehaviorTestClass < BookmarksController
  end

  let(:mock_controller) { BookmarksControllerBehaviorTestClass.new }
  let(:override_config) { mock_controller.blacklight_config }

  describe 'search builder' do
    it 'uses the expected search builder' do
      expect(override_config.search_builder_class).to eq(RollupOnlySearchBuilder)
    end
  end
end
