describe BlacklightHelper do

  describe '#application_name' do

    before { TrlnArgon::Engine.configuration.application_name = 'My Awesome Catalog' }

    it 'should use the configured application name' do
      expect(helper.application_name).to eq('My Awesome Catalog')
    end

  end

end
