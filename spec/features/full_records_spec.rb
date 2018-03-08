describe 'full records' do
  context 'when it displays multiple fields from the record' do
    before { visit solr_document_path(id: 'DUKE002960043') }

    it 'displays the author field label' do
      expect(page).to have_css('dt.blacklight-authors_main_a', text: 'Author:')
    end

    it 'displays the author field value' do
      expect(page).to have_css('dd.blacklight-authors_main_a', text: /.+/)
    end

    it 'displays the physical description field label' do
      expect(page).to have_css('dt.blacklight-description_general_a', text: 'Physical Description:')
    end

    it 'displays the physical description field value' do
      expect(page).to have_css('dd.blacklight-description_general_a', text: /.+/)
    end

    it 'displays the notes field label' do
      expect(page).to have_css('dt.blacklight-notes_indexed_a', text: 'Notes:')
    end

    it 'displays the notes field value' do
      expect(page).to have_css('dd.blacklight-notes_indexed_a', text: /.+/)
    end

    it 'displays the ISBN field label' do
      expect(page).to have_css('dt.blacklight-isbn_with_qualifying_info', text: 'ISBN:')
    end

    it 'displays the ISBN field value' do
      expect(page).to have_css('dd.blacklight-isbn_with_qualifying_info', text: /.+/)
    end
  end

  context 'when it displays a known record with an edition statement indexed' do
    before { visit solr_document_path(id: 'UNCb2224383') }

    it 'displays the edition statement' do
      expect(page).to have_css('li.sub-header.edition_a', text: /5th/)
    end
  end
end
