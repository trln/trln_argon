describe 'search results' do
  context 'when no results found' do
    it 'displays a message for no results found' do
      visit search_catalog_path
      fill_in 'q', with: 'qwertyuiopasdfdghjklzxcvbnm'
      click_button 'search'
      expect(page).to have_content 'No results for your search'
    end
  end

  context 'when some results found' do
    it 'displays the number of results found' do
      visit search_catalog_path
      fill_in 'q', with: ''
      click_button 'search'
      expect(page).to have_content(/\d+ UNC results/)
    end
  end

  context 'when facets applied to search' do
    before do
      visit search_catalog_path(local_filter: 'false')
      click_button 'search'
      click_link 'Music recording'
    end

    it 'displays the Resource Type facet breadcrumb field label' do
      expect(page).to have_css('.filterName', text: 'Resource Type')
    end

    it 'displays the Music Recording facet breadcrumb field value' do
      expect(page).to have_css('.filterValue', text: 'Music recording')
    end
  end

  context 'when location facet applied to search' do
    before do
      visit search_catalog_path(local_filter: 'false')
      click_button 'search'
      click_link 'Law Libraries'
    end

    it 'displays the full location name in the page title' do
      expect(page.title).to have_content(/Location: Law Libraries.*/)
    end
  end

  describe 'paging controls' do
    before do
      visit search_catalog_path(local_filter: 'false')
      click_button 'search'
    end

    it 'provides paging options above the results' do
      expect(page).to have_css('#sortAndPerPage .page_links')
    end

    it 'provides paging options below the search results' do
      expect(page).to have_css('.pagination')
    end
  end

  describe 'date facet filters' do
    before do
      visit search_catalog_path(local_filter: false)
      click_link 'Publication Year'
    end

    it 'provides "2000 to present" date range facet' do
      expect(page).to have_css('#facet-publication_year_isort_stored_single .facet_select', text: '2000 to present')
    end

    it 'provides "1900 to 1999" date range facet' do
      expect(page).to have_css('#facet-publication_year_isort_stored_single .facet_select', text: '1900 to 1999')
    end

    it 'provides "1800 to 1899" date range facet' do
      expect(page).to have_css('#facet-publication_year_isort_stored_single .facet_select', text: '1800 to 1899')
    end

    it 'provides "Before 1800" date range facet' do
      expect(page).to have_css('#facet-publication_year_isort_stored_single .facet_select', text: 'Before 1800')
    end
  end

  describe 'more facet links contain correct local_filter parameter' do
    it 'retains local_filter=true when set' do
      visit search_catalog_path(local_filter: true)
      click_button 'search'
      expect(page).to have_selector(:css,
                                    '#facet-resource_type_f '\
                                    'a.more_facets_link[href="/catalog/facet/resource_type_f?'\
                                    'local_filter=true&q=&search_field=all_fields&utf8=%E2%9C%93"]')
    end

    it 'retains local_filter=false when set' do
      visit search_catalog_path(local_filter: false)
      click_button 'search'
      expect(page).to have_selector(:css,
                                    '#facet-resource_type_f '\
                                    'a.more_facets_link[href="/catalog/facet/resource_type_f?'\
                                    'local_filter=false&q=&search_field=all_fields&utf8=%E2%9C%93"]')
    end
  end

  # removed for brittleness, leaving in as an example of
  # how to select a search field.
  # describe 'when showing results' do
  #  before do
  #    # 'Basic child psychiatry', Philip Barker, 5th ed.
  #    visit search_catalog_path(local_filter: 'true')
  #    fill_in('q', with: '0632019239')
  #    select('ISBN/ISSN', from: 'search_field')
  #    click_button 'search'
  #  end
  #  it 'displays edition statement on specific record' do
  #    expect(page).to have_css('li.index-metadata.edition_a', text: /5th/)
  #  end
  # end
end
