describe AdvancedController do
  render_views

  describe 'search builder class' do
    it 'uses DefaultLocalSearchBuilder' do
      expect(described_class.blacklight_config.search_builder_class).to eq(DefaultLocalSearchBuilder)
    end
  end
end
