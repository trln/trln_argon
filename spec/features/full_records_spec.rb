describe "full records" do

  context "displays multiple fields from the record" do

    before { visit solr_document_path(id: "NCSU3724376") }

    it "displays the title field" do
      expect(page).to have_css("dt.blacklight-title_main", text: "Title:")
      expect(page).to have_css("dd.blacklight-title_main", text: /.+/)
    end

    it "displays the author field" do
      expect(page).to have_css("dt.blacklight-authors_main_a", text: "Author:")
      expect(page).to have_css("dd.blacklight-authors_main_a", text: /.+/)
    end

    it "displays the format field" do
      expect(page).to have_css("dt.blacklight-format_a", text: "Format:")
      expect(page).to have_css("dd.blacklight-format_a", text: /.+/)
    end

    it "displays the URL field" do
      expect(page).to have_css("dt.blacklight-url_href_a", text: "URL:")
      expect(page).to have_css("dd.blacklight-url_href_a", text: /.+/)
    end

    it "displays the language field" do
      expect(page).to have_css("dt.blacklight-language_a", text: "Language:")
      expect(page).to have_css("dd.blacklight-language_a", text: /.+/)
    end

    it "displays the subjects field" do
      expect(page).to have_css("dt.blacklight-subjects_a", text: "Subjects:")
      expect(page).to have_css("dd.blacklight-subjects_a", text: /.+/)
    end

    it "displays the publisher field" do
      expect(page).to have_css("dt.blacklight-publisher_etc_a", text: "Publisher:")
      expect(page).to have_css("dd.blacklight-publisher_etc_a", text: /.+/)
    end

    it "displays the ISBN field" do
      expect(page).to have_css("dt.blacklight-isbn_number_a", text: "ISBN Number:")
      expect(page).to have_css("dd.blacklight-isbn_number_a", text: /.+/)
    end

    it "displays the publication date field" do
      expect(page).to have_css("dt.blacklight-publication_year_isort_stored_single", text: "Date:")
      expect(page).to have_css("dd.blacklight-publication_year_isort_stored_single", text: /.+/)
    end

    it "displays the institution field" do
      expect(page).to have_css("dt.blacklight-institution_a", text: "Institution:")
      expect(page).to have_css("dd.blacklight-institution_a", text: /.+/)
    end

  end

end
