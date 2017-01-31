describe TrlnArgon::ControllerOverride do

  class ControllerOverrideTestClass < CatalogController
  end

  let (:mock_controller) { ControllerOverrideTestClass.new }
  let (:override_config) { mock_controller.blacklight_config }

  describe 'customized blacklight configuration' do

    describe 'search builder' do

      it 'should use the expected search builder' do
        expect(override_config.search_builder_class).to eq(TrlnArgonSearchBuilder)
      end

    end

    describe 'default per page' do

      it 'should set the default per page value' do
        expect(override_config.default_per_page).to eq(20)
      end

    end

    describe 'advanced search' do

      it 'should set the url_key' do
        expect(override_config.advanced_search[:url_key]).to eq('advanced')
      end

      it 'should set the query_parser' do
        expect(override_config.advanced_search[:query_parser]).to eq('dismax')
      end

      it 'should set the form_solr_parameters' do
        expect(override_config.advanced_search[:form_solr_parameters]).to eq({})
      end

    end

  end

end
