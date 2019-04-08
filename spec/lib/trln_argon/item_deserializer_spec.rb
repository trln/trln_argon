describe TrlnArgon::ItemDeserializer do
  class SolrDocumentTestClass
    include Blacklight::Solr::Document
    include TrlnArgon::ItemDeserializer
  end

  context 'document has items but no holdings' do
    let(:document) do
      SolrDocumentTestClass.new(YAML.safe_load(file_fixture('documents/UNCb1865787.yml').read))
    end
    let(:expectation) do
      YAML.safe_load(file_fixture('holdings/UNCb1865787_expectation.yml').read)
    end

    it 'generates holdings info' do
      expect(document.holdings).to eq(expectation)
    end
  end

  context 'document has items and holdings with different locations' do
    let(:document) do
      SolrDocumentTestClass.new(YAML.safe_load(file_fixture('documents/UNCb1852218.yml').read))
    end
    let(:expectation) do
      YAML.safe_load(file_fixture('holdings/UNCb1852218_expectation.yml').read)
    end

    it 'generates holdings info' do
      expect(document.holdings).to eq(expectation)
    end
  end
end
