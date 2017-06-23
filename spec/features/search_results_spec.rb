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

end
