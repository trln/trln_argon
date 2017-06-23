describe "search options" do

  context "search dropdown" do
    it "provides an All Fields search option" do
      visit search_catalog_path
      expect(page).to have_select('search_field', :with_options => ['All Fields'])
    end
  end

end