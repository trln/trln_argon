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
  end

  describe 'it should accept custom configuration values' do
    config = TrlnArgon::Engine::Configuration.new

    config.preferred_records = 'custom_record_field'
    config.local_institution_code = 'custom_institution'
    config.local_records = 'custom_inst, consortium'
    config.apply_local_filter_by_default = 'false'
    config.application_name = 'Custom App Name'

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
  end
end
