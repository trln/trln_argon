describe 'full records' do
  context 'when it displays multiple fields from the record' do
    before { visit solr_document_path(id: 'DUKE002960043') }

    it 'displays the ISBN field label' do
      expect(page).to have_css('dt.blacklight-isbn_with_qualifying_info', text: 'ISBN')
    end

    it 'displays the ISBN field value with qualifying info' do
      expect(page).to have_css(
        'dd.blacklight-isbn_with_qualifying_info',
        text: '0195069714 (cloth : alk. paper)'
      )
    end
  end

  context 'when viewing a rolled up record' do
    before { visit trln_solr_document_path(id: 'DUKE002952265') }

    it 'shows location information for Duke' do
      expect(page).to have_css('#doc_duke002952265 h3', text: 'Duke Libraries')
    end

    # This test will fail until documents are reindexed in Solr
    # due to change in indexing strategy for rollup_id.
    xit 'shows location information for NCSU' do
      expect(page).to have_css('#doc_duke002952265 h3', text: 'NCSU Libraries')
    end
  end

  context 'when it displays a known record with an edition statement indexed' do
    before { visit solr_document_path(id: 'UNCb2224383') }

    it 'displays the edition statement' do
      expect(page).to have_css('li.sub-header.edition_a', text: /5th/)
    end
  end
end
