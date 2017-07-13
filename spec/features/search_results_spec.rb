describe "search results" do

  context "no results found" do
    it "displays a message for no results found" do
      visit search_catalog_path
      fill_in "q", with: "qwertyuiopasdfdghjklzxcvbnm"
      click_button "search"
      expect(page).to have_content "No results found for your search"
    end
  end

  context "some results found" do
    it "displays the number of results found" do
      visit search_catalog_path
      fill_in "q", with: "food"
      click_button "search"
      expect(page).to have_content(/\d+ TRLN results/)
    end
  end

  context 'all results' do
    it 'returns entire catalog when no query string provided' do
      visit search_catalog_path(local_filer: 'false')
      click_button 'search'
      page_entries_text = page.find(:css, '.page_entries').text
      result_count = 0
      page_entries_text.scan(/\b(\d+,?(\d+)?)\b/).each do |match|
        integer = match[0].gsub!(/\D/,'').to_i
        result_count = integer if integer > result_count
      end
      uri = URI("#{CatalogController.blacklight_config.connection_config[:url]}/select?&q=*:*&wt=json")
      solr_count = JSON.parse(Net::HTTP.get(uri))['response']['numFound']

      expect(result_count).to eq(solr_count)
    end
  end

  it "produces expected search from GET parameters (bookmarkable)" do
    visit search_catalog_path({ :q => "food",
          "f[format_f][]" => "Book",
          :sort => "title_sort_ssort_single asc, publication_year_isort_stored_single asc",
          :per_page => "10",
          :page => "2" })
    expect(page).to have_selector("input#q[value='food']")
    expect(page).to have_css("span.filterName", text: "Format")
    expect(page).to have_css("span.filterValue", text: "Book")
    expect(page).to have_css("#sort-dropdown button", text: "Sort by Title (A-Z)")
    expect(page).to have_css("#per_page-dropdown button", text: "10 per page")
    expect(page).to have_css("ul.pagination li.active", text: "2")
  end

  it "adds GET parameters to the URL as a search is constructed (bookmarkable)" do
    visit search_catalog_path(local_filter: "false")
    fill_in "q", with: "food"
    click_button "search"
    click_link "10 per page"
    click_button "Sort by Relevance"
    click_link "Title (A-Z)"
    click_link "Book"
    click_link "2"
    expect(page).to have_current_path(root_path(per_page: "10",
      q: "food",
      sort: "title_sort_ssort_single asc, publication_year_isort_stored_single asc",
      "f[format_f][]" => "Book",
      page: "2",
      local_filter: "false",
      search_field: "all_fields"))
  end

  context "facets applied to search" do
    before do
      visit search_catalog_path(local_filter: "false")
      click_button "search"
      click_link "Format"
      click_link "Print"
      click_link "Book"
    end

    it "displays the Format > Print facet breadcrumb" do
      expect(page).to have_css(".filterName", text: "Format")
      expect(page).to have_css(".filterValue", text: "Print")
    end

    it "displays the Format > Book facet breadcrumb" do
      expect(page).to have_css(".filterName", text: "Format")
      expect(page).to have_css(".filterValue", text: "Book")
    end
  end

  describe "paging controls" do
    before do
      visit search_catalog_path(local_filter: "false")
      click_button "search"
    end

    it "provides paging options above the results" do
      expect(page).to have_css("#sortAndPerPage .page_links")
    end

    it "provides paging options below the search results" do
      expect(page).to have_css(".pagination")
    end
  end

end
