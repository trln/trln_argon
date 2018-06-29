describe TrlnController do
  render_views

  describe 'search builder class' do
    it 'uses DefaultTrlnSearchBuilder' do
      expect(described_class.blacklight_config.search_builder_class).to eq(DefaultTrlnSearchBuilder)
    end
  end
end
