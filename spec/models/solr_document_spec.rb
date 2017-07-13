describe SolrDocument do
  describe 'unique identifier' do
    let(:solrdoc) { described_class.new(id: 'NCSU3724376') }

    describe '#id' do
      subject { solrdoc.id }

      it { is_expected.to eq 'NCSU3724376' }
    end

    it 'uses the Solr id field as its unique key' do
      expect(described_class.unique_key).to eq 'id'
    end
  end
end
