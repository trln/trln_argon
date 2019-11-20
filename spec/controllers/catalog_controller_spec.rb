describe CatalogController do
  include Devise::Test::ControllerHelpers
  render_views

  describe 'search builder class' do
    it 'uses DefaultLocalSearchBuilder' do
      expect(described_class.blacklight_config.search_builder_class).to eq(DefaultLocalSearchBuilder)
    end
  end

  describe 'count only endpoint' do
    routes { TrlnArgon::Engine.routes }
    it 'returns a Solr JSON response' do
      VCR.use_cassette('catalog_controller/count_only_endpoint') do
        get :count_only
        expect(JSON.parse(response.body)).to include('response')
      end
    end
  end

  describe 'deep paging alert' do
    it 'sends the alert message' do
      VCR.use_cassette('catalog_controller/deep_paging_alert') do
        get :index, params: { page: 250 }
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'deep paging error' do
    before { get :index, params: { page: 251 } }

    it 'sends the error message' do
      VCR.use_cassette('catalog_controller/deep_paging_error') do
        expect(flash[:error]).to be_present
      end
    end

    it 'redirects to root' do
      VCR.use_cassette('catalog_controller/deep_paging_error') do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'deep facet paging alert' do
    it 'sends the alert message' do
      VCR.use_cassette('catalog_controller/deep_facet_paging_alert') do
        get :facet, params: { id: 'resource_type_f', 'facet.page' => 50 }
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'deep facet paging error' do
    before { get :facet, params: { id: 'resource_type_f', 'facet.page' => 51 } }

    it 'sends the error message' do
      VCR.use_cassette('catalog_controller/deep_facet_paging_error') do
        expect(flash[:error]).to be_present
      end
    end

    it 'redirects to root' do
      VCR.use_cassette('catalog_controller/deep_facet_paging_error') do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
