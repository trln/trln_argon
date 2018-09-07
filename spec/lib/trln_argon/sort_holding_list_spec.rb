describe TrlnArgon::SortHoldingList do
  class SolrDocumentTestClass
    include Blacklight::Solr::Document
    include TrlnArgon::SolrDocument
  end

  describe 'sort holding list' do
    context 'sort holding list by institution' do
      let(:solr_document1) do
        SolrDocument.new(YAML.safe_load(file_fixture('documents/DUKE003007532.yml').read).first)
      end

      let(:solr_document2) do
        SolrDocument.new(YAML.safe_load(file_fixture('documents/UNCb3917352.yml').read).first)
      end

      let(:grouped_docs) do
        { 'duke' => [solr_document1], 'unc' => [solr_document2] }
      end

      it 'sort holding list' do
        expect(described_class.by_institution(grouped_docs).keys.first).to eq('unc')
      end
    end
  end
end
