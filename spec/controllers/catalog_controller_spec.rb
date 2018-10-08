describe CatalogController do
  render_views

  describe 'search builder class' do
    it 'uses DefaultLocalSearchBuilder' do
      expect(described_class.blacklight_config.search_builder_class).to eq(DefaultLocalSearchBuilder)
    end
  end

  describe 'count only endpoint' do
    routes { TrlnArgon::Engine.routes }
    it 'returns a Solr JSON response' do
      get :count_only
      expect(JSON.parse(response.body)).to include('response')
    end
  end
end
