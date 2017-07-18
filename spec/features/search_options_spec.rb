describe 'search options' do
  context 'search dropdown' do
    before { visit search_catalog_path }

    it 'provides a dropdown with fielded search options' do
      expect(page).to have_select('search_field')
    end

    it 'provides an All Fields search option' do
      expect(page).to have_select('search_field', with_options: ['All Fields'])
    end

    it 'provides a Title search option' do
      expect(page).to have_select('search_field', with_options: ['Title'])
    end
  end
end
