describe TrlnArgon::Field do
  describe 'stored single value field' do
    let(:field) { described_class.new :food }

    before do
      I18n.backend.store_translations(:en,
                                      trln_argon: {
                                        fields: {
                                          food: { label: 'All the Foods' }
                                        }
                                      })
    end

    it 'returns its solr field name' do
      expect(field).to eq('food')
    end

    it 'uses a translated label' do
      expect(field.label).to eq('All the Foods')
    end
  end

  describe 'stored multivalued field' do
    let(:field) { described_class.new :blah_blah_a }

    it 'returns its solr field name' do
      expect(field).to eq('blah_blah_a')
    end

    it 'has a label' do
      expect(field.label).to eq('Blah Blah')
    end
  end

  describe 'facet field' do
    let(:field) { described_class.new :blah_blah_facet }

    it 'returns its solr field name' do
      expect(field).to eq('blah_blah_facet')
    end

    it 'has a label' do
      expect(field.label).to eq('Blah Blah')
    end
  end
end
