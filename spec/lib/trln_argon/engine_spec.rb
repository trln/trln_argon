describe TrlnArgon::Engine do
  describe 'default configuration' do
    config = TrlnArgon::Engine::Configuration.new

    it 'sets the local_institution_code' do
      expect(config.local_institution_code).to eq('unc')
    end

    it 'sets the application_name' do
      expect(config.application_name).to eq('TRLN Argon')
    end

    it 'sets the refworks_url' do
      expect(config.refworks_url).to eq('http://www.refworks.com.libproxy.lib.unc.edu/express/ExpressImport.asp?'\
                                        'vendor=SearchUNC&filter=RIS%20Format&encoding=65001&url=')
    end

    it 'sets the root url' do
      expect(config.root_url).to eq('https://discovery.trln.org')
    end

    it 'sets the article search url' do
      expect(config.article_search_url).to eq(
        'http://libproxy.lib.unc.edu/login?'\
        'url=http://unc.summon.serialssolutions.com/search?'\
        's.secure=f&s.ho=t&s.role=authenticated&s.ps=20&s.q='
      )
    end

    it 'sets the contact URL' do
      expect(config.contact_url).to eq('https://library.unc.edu/ask/')
    end

    it 'sets sort order in holding_list' do
      expect(config.sort_order_in_holding_list).to eq('unc, duke, ncsu, nccu, trln')
    end

    it 'sets number of location facets' do
      expect(config.number_of_location_facets).to eq('10')
    end

    it 'sets number of items in index view' do
      expect(config.number_of_items_index_view).to eq('3')
    end

    it 'sets number of items in show view' do
      expect(config.number_of_items_show_view).to eq('6')
    end

    it 'sets the paging limit' do
      expect(config.paging_limit).to eq('250')
    end

    it 'sets the facet paging limit' do
      expect(config.facet_paging_limit).to eq('50')
    end
  end

  describe 'it should accept custom configuration values' do
    config = TrlnArgon::Engine::Configuration.new

    config.local_institution_code = 'custom_institution'
    config.application_name = 'Custom App Name'
    config.refworks_url = 'http://www.refworks.com/express/ExpressImport.asp?'\
                          'vendor=DUKE&filter=RIS%20Format&encoding=65001&url='
    config.root_url = 'https://catalog.library.duke.edu'
    config.article_search_url = 'https://duke.summon.serialssolutions.com/'\
                                 'advanced#!/search?'\
                                 'ho=t&fvf=ContentType,Journal%20Article,f|'\
                                 'ContentType,Magazine%20Article,f&l=en&q='
    config.contact_url = 'https://library.duke.edu/research/ask'
    config.paging_limit = '100'
    config.facet_paging_limit = '10'

    it 'sets the local_institution_code' do
      expect(config.local_institution_code).to eq('custom_institution')
    end

    it 'sets the application_name' do
      expect(config.application_name).to eq('Custom App Name')
    end

    it 'sets the refworks_url' do
      expect(config.refworks_url).to eq('http://www.refworks.com/express/ExpressImport.asp?'\
                                        'vendor=DUKE&filter=RIS%20Format&encoding=65001&url=')
    end

    it 'sets the root url' do
      expect(config.root_url).to eq('https://catalog.library.duke.edu')
    end

    it 'sets the article search url' do
      expect(config.article_search_url).to eq('https://duke.summon.serialssolutions.com/'\
                                    'advanced#!/search?'\
                                    'ho=t&fvf=ContentType,Journal%20Article,f|'\
                                    'ContentType,Magazine%20Article,f&l=en&q=')
    end

    it 'sets the contact url' do
      expect(config.contact_url).to eq('https://library.duke.edu/research/ask')
    end

    it 'sets the sort order in holding list' do
      expect(config.sort_order_in_holding_list).to eq('unc, duke, ncsu, nccu, trln')
    end

    it 'sets number of location facets' do
      expect(config.number_of_location_facets).to eq('10')
    end

    it 'sets number of items in index view' do
      expect(config.number_of_items_index_view).to eq('3')
    end

    it 'sets number of items in show view' do
      expect(config.number_of_items_show_view).to eq('6')
    end

    it 'sets the paging limit' do
      expect(config.paging_limit).to eq('100')
    end

    it 'sets the facet paging limit' do
      expect(config.facet_paging_limit).to eq('10')
    end
  end
end
