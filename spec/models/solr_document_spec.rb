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

    it 'is configured to use the document document_solr_path' do
      expect(described_class.repository.blacklight_config.document_solr_path).to eq :document
    end

    it 'does not set the document_solr_request_handler' do
      expect(described_class.repository.blacklight_config.document_solr_request_handler).to be_nil
    end

    it 'registers Ris as a document extension' do
      expect(described_class.registered_extensions).to include(
        module_obj: TrlnArgon::Document::Ris, condition_proc: nil
      )
    end
  end
end
