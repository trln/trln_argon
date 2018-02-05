describe TrlnArgon::ViewHelpers::DocumentExportHelper, type: :helper do
  describe '#argon_refworks_path' do
    it 'returns a path to refworks export' do
      expect(helper.argon_refworks_path(id: 'DUKE122335')).to eq(
        'http://www.refworks.com.libproxy.lib.unc.edu/express/ExpressImport.asp?'\
        'vendor=SearchUNC&filter=RIS%20Format&encoding=65001&url=http://test.host/catalog/DUKE122335.ris'
      )
    end
  end

  describe '#ris_path' do
    it 'returns a path to the RIS formatted document' do
      expect(helper.ris_path(id: 'DUKE122335')).to eq('/catalog/DUKE122335.ris')
    end
  end

  describe '#ris_url' do
    it 'returns a URL for the RIS formatted document' do
      expect(helper.ris_url(id: 'DUKE122335')).to eq(
        'http://test.host/catalog/DUKE122335.ris'
      )
    end
  end

  describe '#render_ris' do
    let(:doc_1) { SolrDocument.new(id: 'DUKE001', institution_a: 'duke') }
    let(:doc_2) { SolrDocument.new(id: 'DUKE002', institution_a: 'duke') }

    it 'returns an ris file assembled from multiple documents' do
      expect(helper.render_ris([doc_1, doc_2])).to eq(
        "TY  - GEN\r\n"\
        "ID  - DUKE001\r\n"\
        "UR  - https://discovery.trln.org/catalog/DUKE001\r\n"\
        "ER  - \r\n"\
        "TY  - GEN\r\n"\
        "ID  - DUKE002\r\n"\
        "UR  - https://discovery.trln.org/catalog/DUKE002\r\n"\
        'ER  - '\
      )
    end
  end
end
