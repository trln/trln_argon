describe 'search options' do
  context 'when displaying search dropdown' do
    before do
      VCR.use_cassette('search_options/search_dropdown') do
        visit search_catalog_path
      end
    end

    it 'provides a dropdown with fielded search options' do
      expect(page).to have_select('search_field')
    end

    it 'provides an All Fields search option' do
      expect(page).to have_select('search_field', with_options: ['All Fields'])
    end

    it 'provides a Title search option' do
      expect(page).to have_select('search_field', with_options: ['Title'])
    end

    it 'provides an Author search option' do
      expect(page).to have_select('search_field', with_options: ['Author'])
    end

    it 'provides a Subject search option' do
      expect(page).to have_select('search_field', with_options: ['Subject'])
    end
  end
end
