describe TrlnArgon::ControllerOverride do

  class ControllerOverrideTestClass < CatalogController
  end

  let (:mock_controller) { ControllerOverrideTestClass.new }
  let (:override_config) { mock_controller.blacklight_config }

  describe "customized blacklight configuration" do

    describe "search builder" do

      it "should use the expected search builder" do
        expect(override_config.search_builder_class).to eq(TrlnArgonSearchBuilder)
      end

    end

    describe "default per page" do

      it "should set the default per page value" do
        expect(override_config.default_per_page).to eq(20)
      end

    end

    describe "advanced search" do

      it "should set the url_key" do
        expect(override_config.advanced_search[:url_key]).to eq("advanced")
      end

      it "should set the query_parser" do
        expect(override_config.advanced_search[:query_parser]).to eq("dismax")
      end

      it "should set the form_solr_parameters" do
        expect(override_config.advanced_search[:form_solr_parameters]).to eq({})
      end

    end

    describe "title field" do

      it "should set the title field" do
        expect(override_config.index.title_field).to eq("title_main")
      end

    end

    describe "display type field" do

      it "should set the display type field" do
        expect(override_config.index.display_type_field).to eq("format_a")
      end

    end

    describe "facet fields" do

      it "should set the format facet" do
        expect(override_config.facet_fields).to have_key("format_f")
      end

      it "should set the subject facet" do
        expect(override_config.facet_fields).to have_key("subjects_f")
      end

      it "should set the language facet" do
        expect(override_config.facet_fields).to have_key("language_f")
      end

      it "should set the call number facet" do
        expect(override_config.facet_fields).to have_key("items_lcc_top_f")
      end

      it "should set the items location facet" do
        expect(override_config.facet_fields).to have_key("items_location_f")
      end

      it "should set the institution facet" do
        expect(override_config.facet_fields).to have_key("institution_f")
      end

    end

    describe "index fields" do

      it "should set the title main vernacular field" do
        expect(override_config.index_fields).to have_key("title_main_vern")
      end

      it "should set the authors main field" do
        expect(override_config.index_fields).to have_key("authors_main_a")
      end

      it "should set the authors main vernacular field" do
        expect(override_config.index_fields).to have_key("authors_main_vern")
      end

      it "should set the format field" do
        expect(override_config.index_fields).to have_key("format_a")
      end

      it "should set the language field" do
        expect(override_config.index_fields).to have_key("language_a")
      end

      it "should set the publisher name field" do
        expect(override_config.index_fields).to have_key("publisher_etc_a")
      end

      it "should set the publication year field" do
        expect(override_config.index_fields).to have_key("publication_year_isort_stored_single")
      end

      it "should set the institution field" do
        expect(override_config.index_fields).to have_key("institution_a")
      end

    end

    describe "show fields" do

      it "should set the title main field" do
        expect(override_config.show_fields).to have_key("title_main")
      end

      it "should set the authors main field" do
        expect(override_config.show_fields).to have_key("authors_main_a")
      end

      it "should set the format field" do
        expect(override_config.show_fields).to have_key("format_a")
      end

      it "should set the URL field" do
        expect(override_config.show_fields).to have_key("url_href_a")
      end

      it "should set the title language field" do
        expect(override_config.show_fields).to have_key("language_a")
      end

      it "should set the subjects field" do
        expect(override_config.show_fields).to have_key("subjects_a")
      end

      it "should set the publisher field" do
        expect(override_config.show_fields).to have_key("publisher_etc_a")
      end

      it "should set the ISBN field" do
        expect(override_config.show_fields).to have_key("isbn_number_a")
      end

      it "should set the publication year field" do
        expect(override_config.show_fields).to have_key("publication_year_isort_stored_single")
      end

      it "should set the institution field" do
        expect(override_config.show_fields).to have_key("institution_a")
      end

    end

    describe "search fields" do

      describe "all fields" do

        it "should set the all fields field" do
          expect(override_config.search_fields).to have_key("all_fields")
        end

        it "should have a label" do
          expect(override_config.search_fields['all_fields'].label).to eq("All Fields")
        end

      end

      describe "title field" do

        it "should set the title field" do
          expect(override_config.search_fields).to have_key("title")
        end

        it "should have a label" do
          expect(override_config.search_fields['title'].label).to eq("Title")
        end

      end

      describe "author field" do

        it "should set the author field" do
          expect(override_config.search_fields).to have_key("author")
        end

        it "should have a label" do
          expect(override_config.search_fields['author'].label).to eq("Author")
        end

      end

      describe "subject field" do

        it "should set the subject field" do
          expect(override_config.search_fields).to have_key("subject")
        end

        it "should have a label" do
          expect(override_config.search_fields['subject'].label).to eq("Subject")
        end

      end

    end

    describe "sort fields" do

      describe "Relevance" do

        let(:fields) { "score desc, publication_year_isort_stored_single desc, title_sort_ssort_single asc" }

        it "should set the sort fields" do
          expect(override_config.sort_fields).to have_key(fields)
        end

        it "should set the label" do
          expect(override_config.sort_fields[fields].label).to eq("Relevance")
        end

      end

      describe "Year: New to Old" do

        let(:fields) { "publication_year_isort_stored_single desc, title_sort_ssort_single asc" }

        it "should set the sort fields" do
          expect(override_config.sort_fields).to have_key(fields)
        end

        it "should set the label" do
          expect(override_config.sort_fields[fields].label).to eq("Year (new to old)")
        end

      end

      describe "Title: A to Z" do

        let(:fields) { "title_sort_ssort_single asc, publication_year_isort_stored_single asc" }

        it "should set the sort fields" do
          expect(override_config.sort_fields).to have_key(fields)
        end

        it "should set the label" do
          expect(override_config.sort_fields[fields].label).to eq("Title (A-Z)")
        end

      end

    end

  end

end
