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
      click_link 'ncsu'
      expect(page).to have_current_path(
        root_path(
          :q                  => '',
          'f[format_f]'       => %w[Print Book],
          'f[institution_f]'  => %w[ncsu],
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
