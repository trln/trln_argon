describe 'full records' do
  context 'when it displays multiple fields from the record' do
    before do
      VCR.use_cassette('full_records/DUKE002960043') do
        visit solr_document_path(id: 'DUKE002960043')
      end
    end

    it 'displays the ISBN field label' do
      expect(page).to have_css('dt.blacklight-isbn_with_qualifying_info', text: 'ISBN')
    end

    it 'displays the ISBN field value with qualifying info' do
      expect(page).to have_css(
        'dd.blacklight-isbn_with_qualifying_info',
        text: '0195069714'
      )
    end
  end

  context 'when viewing a rolled up record' do
    before do
      VCR.use_cassette('full_records/DUKE002952265') do
        visit trln_solr_document_path(id: 'DUKE002952265')
      end
    end

    it 'shows location information for Duke' do
      expect(page).to have_css('#doc_duke002952265 h3', text: 'Duke Libraries')
    end

    it 'shows location information for NCSU' do
      expect(page).to have_css('#doc_duke002952265 h3', text: 'NC State University Libraries')
    end
  end

  context 'when it displays a known record with an edition statement indexed' do
    before do
      VCR.use_cassette('full_records/UNCb2224383') do
        visit solr_document_path(id: 'UNCb2224383')
      end
    end

    it 'displays the edition statement' do
      expect(page).to have_css('dd.blacklight-edition_a', text: /5th/)
    end
  end
end
