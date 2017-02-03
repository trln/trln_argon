describe TrlnArgon::Engine do

  describe 'default configuration' do

    config = TrlnArgon::Engine::Configuration.new

    it 'should set the rollup_field' do
      expect(config.rollup_field).to eq('rollup_id')
    end

    it 'should set the preferred_record_field' do
      expect(config.preferred_record_field).to eq('owner')
    end

    it 'should set the preferred_record_value' do
      expect(config.preferred_record_value).to eq('duke')
    end

    it 'should set the local_institution' do
      expect(config.local_institution).to eq('duke')
    end

    it 'should set the local_records_field' do
      expect(config.local_records_field).to eq('owner')
    end

    it 'should set the local_records_values' do
      expect(config.local_records_values).to eq(['duke', 'trln'])
    end

    it 'should set apply_local_filter_by_default' do
      expect(config.apply_local_filter_by_default).to eq('true')
    end

    it 'should set the application_name' do
      expect(config.application_name).to eq('TRLN Argon')
    end

  end

  describe 'it should accept custom configuration values' do

    config = TrlnArgon::Engine::Configuration.new

    config.rollup_field = 'custom_rollup_field'
    config.preferred_record_field = 'custom_record_field'
    config.preferred_record_value = 'custom_record_value'
    config.local_institution = 'custom_institution'
    config.local_records_field = 'custom_local_record_field'
    config.local_records_values = ['custom_institution', 'consortium']
    config.apply_local_filter_by_default = 'false'
    config.application_name = 'Custom App Name'

    it 'should set the rollup_field' do
      expect(config.rollup_field).to eq('custom_rollup_field')
    end

    it 'should set the preferred_record_field' do
      expect(config.preferred_record_field).to eq('custom_record_field')
    end

    it 'should set the preferred_record_value' do
      expect(config.preferred_record_value).to eq('custom_record_value')
    end

    it 'should set the local_institution' do
      expect(config.local_institution).to eq('custom_institution')
    end

    it 'should set the local_records_field' do
      expect(config.local_records_field).to eq('custom_local_record_field')
    end

    it 'should set the local_records_values' do
      expect(config.local_records_values).to eq(['custom_institution', 'consortium'])
    end

    it 'should set apply_local_filter_by_default' do
      expect(config.apply_local_filter_by_default).to eq('false')
    end

    it 'should set the application_name' do
      expect(config.application_name).to eq('Custom App Name')
    end
  end


end
