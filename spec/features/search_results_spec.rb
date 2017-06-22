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

end
