module TrlnArgon
  RSpec.describe Fields do

    describe "constants" do

      it "should have a ROLLUP_ID" do
        expect(Fields::ROLLUP_ID.label).to eq("Rollup")
        expect(Fields::ROLLUP_ID.solr_name).to eq('rollup_id')
      end

      it "should have a AUTHORS_MAIN" do
        expect(Fields::AUTHORS_MAIN.label).to eq("Author")
        expect(Fields::AUTHORS_MAIN.solr_name).to eq('authors_main_a')
      end

      it "should have a AUTHORS_MAIN_VERN" do
        expect(Fields::AUTHORS_MAIN_VERN.label).to eq("Authors Main Vern")
        expect(Fields::AUTHORS_MAIN_VERN.solr_name).to eq('authors_main_vern')
      end

      it "should have a FORMAT" do
        expect(Fields::FORMAT.label).to eq("Format")
        expect(Fields::FORMAT.solr_name).to eq('format_a')
      end

      it "should have a INSTITUTION" do
        expect(Fields::INSTITUTION.label).to eq("Institution")
        expect(Fields::INSTITUTION.solr_name).to eq('institution_a')
      end

      it "should have a ISBN_NUMBER" do
        expect(Fields::ISBN_NUMBER.label).to eq("ISBN Number")
        expect(Fields::ISBN_NUMBER.solr_name).to eq('isbn_number_a')
      end

      it "should have a LANGUAGE" do
        expect(Fields::LANGUAGE.label).to eq("Language")
        expect(Fields::LANGUAGE.solr_name).to eq('language_a')
      end

      it "should have a PUBLISHER_ETC_NAME" do
        expect(Fields::PUBLISHER_ETC_NAME.label).to eq("Publisher")
        expect(Fields::PUBLISHER_ETC_NAME.solr_name).to eq('publisher_etc_name_a')
      end

      it "should have a TITLE_MAIN" do
        expect(Fields::TITLE_MAIN.label).to eq("Title")
        expect(Fields::TITLE_MAIN.solr_name).to eq('title_main')
      end

      it "should have a TITLE_MAIN_VERN" do
        expect(Fields::TITLE_MAIN_VERN.label).to eq("Title Main Vern")
        expect(Fields::TITLE_MAIN_VERN.solr_name).to eq('title_main_vern')
      end

      it "should have a URL_HREF" do
        expect(Fields::URL_HREF.label).to eq("URL")
        expect(Fields::URL_HREF.solr_name).to eq('url_href_a')
      end

      it "should have a CALL_NUMBER_FACET" do
        expect(Fields::CALL_NUMBER_FACET.label).to eq("Call Number")
        expect(Fields::CALL_NUMBER_FACET.solr_name).to eq('items_lcc_top_f')
      end

      it "should have a FORMAT_FACET" do
        expect(Fields::FORMAT_FACET.label).to eq("Format")
        expect(Fields::FORMAT_FACET.solr_name).to eq('format_f')
      end

      it "should have a INSTITUTION_FACET" do
        expect(Fields::INSTITUTION_FACET.label).to eq("Institution")
        expect(Fields::INSTITUTION_FACET.solr_name).to eq('institution_f')
      end

      it "should have a LANGUAGE_FACET" do
        expect(Fields::LANGUAGE_FACET.label).to eq("Language")
        expect(Fields::LANGUAGE_FACET.solr_name).to eq('language_f')
      end

      it "should have a SUBJECTS_FACET" do
        expect(Fields::SUBJECTS_FACET.label).to eq("Subjects")
        expect(Fields::SUBJECTS_FACET.solr_name).to eq('subjects_f')
      end

      it "should have a PUBLICATION_DATE_SORT" do
        expect(Fields::PUBLICATION_DATE_SORT.label).to eq("Date")
        expect(Fields::PUBLICATION_DATE_SORT.solr_name).to eq('publication_year_isort_stored_single')
      end

      it "should have a TITLE_SORT" do
        expect(Fields::TITLE_SORT.label).to eq("Title Sort Ssort Single")
        expect(Fields::TITLE_SORT.solr_name).to eq('title_sort_ssort_single')
      end

    end

  end
end