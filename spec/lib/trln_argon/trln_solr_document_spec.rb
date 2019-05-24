describe TrlnArgon::TrlnSolrDocument do
  class TrlnSolrDocumentTestClass
    include Blacklight::Solr::Document
    include TrlnArgon::TrlnSolrDocument
  end

  describe 'link_to_record' do
    let(:link_document) do
      TrlnSolrDocumentTestClass.new(
        id: 'UNCb6060605'
      )
    end

    it 'returns a link to the record' do
      expect(link_document.link_to_record).to eq(
        'https://discovery.trln.org/trln/UNCb6060605'
      )
    end
  end
end
