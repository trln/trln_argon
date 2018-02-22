describe TrlnArgon::Engine do
  describe 'default configuration' do
    config = TrlnArgon::Engine::Configuration.new

    it 'sets the preferred_records' do
      expect(config.preferred_records).to eq('unc')
    end

    it 'sets the local_institution_code' do
      expect(config.local_institution_code).to eq('unc')
    end

    it 'sets the local_records' do
      expect(config.local_records).to eq('unc,trln')
    end

    it 'sets apply_local_filter_by_default' do
      expect(config.apply_local_filter_by_default).to eq('true')
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
  end

  describe 'it should accept custom configuration values' do
    config = TrlnArgon::Engine::Configuration.new

    config.preferred_records = 'custom_record_field'
    config.local_institution_code = 'custom_institution'
    config.local_records = 'custom_inst, consortium'
    config.apply_local_filter_by_default = 'false'
    config.application_name = 'Custom App Name'
    config.refworks_url = 'http://www.refworks.com/express/ExpressImport.asp?'\
                          'vendor=DUKE&filter=RIS%20Format&encoding=65001&url='
    config.root_url = 'https://catalog.library.duke.edu'
    config.article_search_url = 'https://duke.summon.serialssolutions.com/'\
                                 'advanced#!/search?'\
                                 'ho=t&fvf=ContentType,Journal%20Article,f|'\
                                 'ContentType,Magazine%20Article,f&l=en&q='
    config.contact_url = 'https://library.duke.edu/research/ask'

    it 'sets the preferred_records' do
      expect(config.preferred_records).to eq('custom_record_field')
    end

    it 'sets the local_institution_code' do
      expect(config.local_institution_code).to eq('custom_institution')
    end

    it 'sets the local_records' do
      expect(config.local_records).to eq('custom_inst, consortium')
    end

    it 'sets apply_local_filter_by_default' do
      expect(config.apply_local_filter_by_default).to eq('false')
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
  end
end
