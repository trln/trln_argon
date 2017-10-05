describe 'full records' do
  context 'displays multiple fields from the record' do
    before { visit solr_document_path(id: 'DUKE002960043') }

    it 'displays the title field label' do
      expect(page).to have_css('dt.blacklight-title_main', text: 'Title:')
    end

    it 'displays the title field value' do
      expect(page).to have_css('dd.blacklight-title_main', text: /.+/)
    end

    it 'displays the author field label' do
      expect(page).to have_css('dt.blacklight-authors_main_a', text: 'Author:')
    end

    it 'displays the author field value' do
      expect(page).to have_css('dd.blacklight-authors_main_a', text: /.+/)
    end

    it 'displays the format field label' do
      expect(page).to have_css('dt.blacklight-format_a', text: 'Format:')
    end

    it 'displays the format field value' do
      expect(page).to have_css('dd.blacklight-format_a', text: /.+/)
    end

    it 'displays the language field label' do
      expect(page).to have_css('dt.blacklight-language_a', text: 'Language:')
    end

    it 'displays the language field value' do
      expect(page).to have_css('dd.blacklight-language_a', text: /.+/)
    end

    it 'displays the subjects field label' do
      expect(page).to have_css('dt.blacklight-subjects_a', text: 'Subjects:')
    end

    it 'displays the subjects field value' do
      expect(page).to have_css('dd.blacklight-subjects_a', text: /.+/)
    end

    it 'displays the publication date field label' do
      expect(page).to have_css('dt.blacklight-publication_year_isort_stored_single', text: 'Publication Year:')
    end

    it 'displays the publication date field value' do
      expect(page).to have_css('dd.blacklight-publication_year_isort_stored_single', text: /.+/)
    end

    it 'displays the institution field label' do
      expect(page).to have_css('dt.blacklight-institution_a', text: 'Institution:')
    end

    it 'displays the institution field value' do
      expect(page).to have_css('dd.blacklight-institution_a', text: /.+/)
    end
  end
end
