describe 'search results' do
  context 'no results found' do
    it 'displays a message for no results found' do
      visit search_catalog_path
      fill_in 'q', with: 'qwertyuiopasdfdghjklzxcvbnm'
      click_button 'search'
      expect(page).to have_content 'No results found for your search'
    end
  end

  context 'some results found' do
    it 'displays the number of results found' do
      visit search_catalog_path
      fill_in 'q', with: 'food'
      click_button 'search'
      expect(page).to have_content(/\d+ TRLN results/)
    end
  end

  context 'all results' do
    def result_count
      visit search_catalog_path(local_filer: 'false')
      click_button 'search'
      page_entries_text = page.find(:css, '.page_entries').text
      result_count = 0
      page_entries_text.scan(/\b(\d+,?(\d+)?)\b/).each do |match|
        integer = match[0].gsub!(/\D/, '').to_i
        result_count = integer if integer > result_count
      end
      result_count
    end

    def solr_count
      uri = URI("#{CatalogController.blacklight_config.connection_config[:url]}/select?&q=*:*&wt=json")
      JSON.parse(Net::HTTP.get(uri))['response']['numFound']
    end

    it 'returns entire catalog when no query string provided' do
      expect(result_count).to eq(solr_count)
    end
  end

  describe 'produces expected search from GET parameters (bookmarkable)' do
    before do
      visit search_catalog_path(
        :q              => 'food',
        'f[format_f][]' => 'Book',
        :sort           => 'title_sort_ssort_single asc, publication_year_isort_stored_single asc',
        :per_page       => '10',
        :page           => '2'
      )
    end

    it 'shows the query for "food" in the search box' do
      expect(page).to have_selector('input#q[value="food"]')
    end

    it 'has a Format facet applied' do
      expect(page).to have_css('span.filterName', text: 'Format')
    end

    it 'has the Format > Book facet applied' do
      expect(page).to have_css('span.filterValue', text: 'Book')
    end

    it 'shows the results sorted by Title (A-Z)' do
      expect(page).to have_css('#sort-dropdown button', text: 'Sort by Title (A-Z)')
    end

    it 'has the 10 per page option selected' do
      expect(page).to have_css('#per_page-dropdown button', text: '10 per page')
    end

    it 'is displaying the 2nd page of results' do
      expect(page).to have_css('ul.pagination li.active', text: '2')
    end
  end

  it 'GET paramters added to the URL as a search is constructed (bookmarkable)' do
    visit search_catalog_path(local_filter: 'false')
    fill_in 'q', with: 'food'
    click_button 'search'
    click_link '10 per page'
    click_button 'Sort by Relevance'
    click_link 'Title (A-Z)'
    click_link 'Book'
    click_link '2'
    expect(page).to have_current_path(
      root_path(
        :per_page       => '10',
        :q              => 'food',
        :sort           => 'title_sort_ssort_single asc, publication_year_isort_stored_single asc',
        'f[format_f][]' => 'Book',
        :page           => '2',
        :local_filter   => 'false',
        :search_field   => 'all_fields'
      )
    )
  end

  context 'facets applied to search' do
    before do
      visit search_catalog_path(local_filter: 'false')
      click_button 'search'
      click_link 'Format'
      click_link 'Print'
      click_link 'Book'
    end

    it 'displays the Format facet breadcrumb field label' do
      expect(page).to have_css('.filterName', text: 'Format')
    end

    it 'displays the Format > Print facet breadcrumb field value' do
      expect(page).to have_css('.filterValue', text: 'Print')
    end

    it 'displays the Format > Book facet breadcrumb field value' do
      expect(page).to have_css('.filterValue', text: 'Book')
    end

    it 'adds the facet(s) as a GET parameter to the URL' do
      click_link 'Institution'
      click_link 'unc'
      expect(page).to have_current_path(
        root_path(
          :q                  => '',
          'f[format_f]'       => %w[Print Book],
          'f[institution_f]'  => %w[unc],
          :local_filter       => 'false',
          :search_field       => 'all_fields'
        )
      )
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
end
