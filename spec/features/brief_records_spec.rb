describe "brief records" do

  describe "displays multiple fields from the record" do

    before do
      visit search_catalog_path
      click_button "search"
    end

    it "displays the author field" do
      brief_records = page.find(:css, "#documents:first-of-type")
      expect(brief_records).to have_css("dt.blacklight-authors_main_a", text: "Author:")
      expect(brief_records).to have_css("dd.blacklight-authors_main_a", text: /.+/)
    end

    it "displays the format field" do
      brief_records = page.find(:css, "#documents:first-of-type")
      expect(brief_records).to have_css("dt.blacklight-format_a", text: "Format:")
      expect(brief_records).to have_css("dd.blacklight-format_a", text: /.+/)
    end

    it "displays the language field" do
      brief_records = page.find(:css, "#documents:first-of-type")
      expect(brief_records).to have_css("dt.blacklight-language_a", text: "Language:")
      expect(brief_records).to have_css("dd.blacklight-language_a", text: /.+/)
    end

    it "displays the publisher field" do
      brief_records = page.find(:css, "#documents:first-of-type")
      expect(brief_records).to have_css("dt.blacklight-publisher_etc_a", text: "Publisher:")
      expect(brief_records).to have_css("dd.blacklight-publisher_etc_a", text: /.+/)
    end

    it "displays the publication year field" do
      brief_records = page.find(:css, "#documents:first-of-type")
      expect(brief_records).to have_css("dt.blacklight-publication_year_isort_stored_single", text: "Date:")
      expect(brief_records).to have_css("dd.blacklight-publication_year_isort_stored_single", text: /.+/)
    end

    it "displays the institution field" do
      brief_records = page.find(:css, "#documents:first-of-type")
      expect(brief_records).to have_css("dt.blacklight-institution_a", text: "Institution:")
      expect(brief_records).to have_css("dd.blacklight-institution_a", text: /.+/)
    end

  end

  it "has a title that links to the full record" do
    visit search_catalog_path
    click_button "search"
    brief_record_title = page.find(".document-position-0 .document-title-heading")
    expect(brief_record_title).to have_link(nil, href: /\/catalog\/.+/)
  end

end
