describe TrlnArgon::Field do
  describe 'stored single value field' do
    let(:field) { described_class.new(:food, en: 'All the Foods') }

    it 'returns its solr field name' do
      expect(field).to eq('food')
    end

    it 'uses a translated label' do
      expect(field.label).to eq('All the Foods')
    end
  end
end
