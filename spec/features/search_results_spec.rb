describe 'search results' do
  context 'when no results found' do
    it 'displays a message for no results found' do
      VCR.use_cassette('search_results/no_results_found') do
        visit search_catalog_path
        fill_in 'q', with: 'qwertyuiopasdfdghjklzxcvbnm'
        click_button 'search'
        expect(page).to have_content 'There are no results at any Triangle Research Libraries'
      end
    end
  end

  context 'when facets applied to search' do
    before do
      VCR.use_cassette('search_results/facets_applied') do
        visit search_catalog_path
        click_button 'search'
        click_link 'Music recording'
      end
    end

    it 'displays the Resource Type facet breadcrumb field label' do
      expect(page).to have_css('.filter-name', text: 'Resource Type')
    end

    it 'displays the Music Recording facet breadcrumb field value' do
      expect(page).to have_css('.filter-value', text: 'Music recording')
    end
  end

  context 'when location facet applied to search' do
    before do
      VCR.use_cassette('search_results/location_facet_applied') do
        visit search_catalog_path
        click_button 'search'
        click_link 'Law Library'
      end
    end

    it 'displays the full location name in the page title' do
      expect(page.title).to have_content(/.*Law Library.*/)
    end
  end

  describe 'paging controls' do
    before do
      VCR.use_cassette('search_results/paging_controls') do
        visit search_catalog_path
        fill_in 'q', with: 'book'
        click_button 'search'
      end
    end

    it 'provides paging options above the results' do
      expect(page).to have_css('#sortAndPerPage .page-links')
    end

    it 'provides paging options below the search results' do
      expect(page).to have_css('.pagination')
    end
  end

  context 'when checkbox facet is configured' do
    it 'renders a checkbox field in the facet' do
      VCR.use_cassette('search_results/checkbox_facet') do
        visit search_catalog_path
        expect(page).to have_selector(:css, '#f_inclusive_access_type_f_1')
      end
    end
  end

  describe 'sorting of location hierachy facet' do
    it 'sorts the values by hits, descending' do
      VCR.use_cassette('search_results/location_hierarchy_facet') do
        visit search_catalog_path
        click_button 'search'
        expect(page).to have_selector(
          :css,
          '#facet-location_hierarchy_f .facet-hierarchy .h-node .h-node:first-child',
          text: 'Davis Library'
        )
      end
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
