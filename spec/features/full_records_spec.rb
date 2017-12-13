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
      expect(page).to have_css('dt.blacklight-isbn_number_a', text: 'ISBN:')
    end

    it 'displays the ISBN field value' do
      expect(page).to have_css('dd.blacklight-isbn_number_a', text: /.+/)
    end
  end
end
