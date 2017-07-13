describe CatalogController do
  render_views

  describe 'search builder class' do
    it 'uses TrlnArgonSearchBuilder' do
      expect(described_class.blacklight_config.search_builder_class).to eq(TrlnArgonSearchBuilder)
    end
  end

  # TODO: I get a `uninitialized constant Blacklight::Solr::Repository::RSolr` error
  # with this test. Might be some Solr testing setup needed. Further investigation required.

  # describe 'set local_filter session' do

  #   it 'should set the nav context' do
  #     get :index, local_filter: 'false'
  #     expect(session[:local_filter]).to eq('false')
  #   end

  # end
end
