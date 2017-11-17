describe TrlnArgon::SolrDocument do
  class SolrDocumentTestClass
    include Blacklight::Solr::Document
    include TrlnArgon::SolrDocument
  end

  describe 'availability' do
    context 'when availability is set on the document' do
      let(:solr_document) do
        SolrDocumentTestClass.new(
          id: 'NCSU12345',
          available_a: 'Available'
        )
      end

      it 'returns the correct availability status' do
        expect(solr_document.availability).to eq 'Available'
      end
    end

    context 'when availability is not set on the document' do
      let(:solr_document) do
        SolrDocumentTestClass.new(
          id: 'NCSU12345'
        )
      end

      it 'returns the correct availability status' do
        expect(solr_document.availability).to eq 'Not Available'
      end
    end
  end
end
