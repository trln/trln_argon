describe TrlnArgon::ControllerOverride do
  class ControllerOverrideTestClass < CatalogController
  end

  let(:mock_controller) { ControllerOverrideTestClass.new }
  let(:override_config) { mock_controller.blacklight_config }

  describe 'search builder' do
    it 'uses the expected search builder' do
      expect(override_config.search_builder_class).to eq(TrlnArgonSearchBuilder)
    end
  end

  describe 'default per page' do
    it 'sets the default per page value' do
      expect(override_config.default_per_page).to eq(20)
    end
  end

  describe 'advanced search' do
    it 'sets the url_key' do
      expect(override_config.advanced_search[:url_key]).to eq('advanced')
    end

    it 'sets the query_parser' do
      expect(override_config.advanced_search[:query_parser]).to eq('edismax')
    end

    it 'sets the form_solr_parameters' do
      expect(override_config.advanced_search[:form_solr_parameters]).to eq({})
    end
  end

  describe 'title field' do
    it 'sets the title field' do
      expect(override_config.index.title_field).to eq('title_main')
    end
  end

  describe 'display type field' do
    it 'sets the display type field' do
      expect(override_config.index.display_type_field).to eq('format_a')
    end
  end

  describe 'facet fields' do
    it 'sets the format facet' do
      expect(override_config.facet_fields).to have_key('format_f')
    end

    it 'sets the subject facet' do
      expect(override_config.facet_fields).to have_key('subjects_f')
    end

    it 'sets the language facet' do
      expect(override_config.facet_fields).to have_key('language_f')
    end

    it 'sets the call number facet' do
      expect(override_config.facet_fields).to have_key('items_lcc_top_f')
    end

    it 'sets the items location facet' do
      expect(override_config.facet_fields).to have_key('items_location_f')
    end

    it 'sets the institution facet' do
      expect(override_config.facet_fields).to have_key('institution_f')
    end
  end

  describe 'index fields' do
    it 'sets the title main vernacular field' do
      expect(override_config.index_fields).to have_key('title_main_vern')
    end

    it 'sets the authors main field' do
      expect(override_config.index_fields).to have_key('authors_main_a')
    end

    it 'sets the authors main vernacular field' do
      expect(override_config.index_fields).to have_key('authors_main_vern')
    end

    it 'sets the format field' do
      expect(override_config.index_fields).to have_key('format_a')
    end

    it 'sets the language field' do
      expect(override_config.index_fields).to have_key('language_a')
    end

    it 'sets the publisher name field' do
      expect(override_config.index_fields).to have_key('publisher_etc_a')
    end

    it 'sets the publication year field' do
      expect(override_config.index_fields).to have_key('publication_year_isort_stored_single')
    end

    it 'sets the institution field' do
      expect(override_config.index_fields).to have_key('institution_a')
    end

    it 'sets the URL field' do
      expect(override_config.index_fields).to have_key('url_href_a')
    end
  end

  describe 'show fields' do
    it 'sets the title main field' do
      expect(override_config.show_fields).to have_key('title_main')
    end

    it 'sets the authors main field' do
      expect(override_config.show_fields).to have_key('authors_main_a')
    end

    it 'sets the format field' do
      expect(override_config.show_fields).to have_key('format_a')
    end

    it 'sets the title language field' do
      expect(override_config.show_fields).to have_key('language_a')
    end

    it 'sets the subjects field' do
      expect(override_config.show_fields).to have_key('subjects_a')
    end

    it 'sets the publisher field' do
      expect(override_config.show_fields).to have_key('publisher_etc_a')
    end

    it 'sets the ISBN field' do
      expect(override_config.show_fields).to have_key('isbn_number_a')
    end

    it 'sets the publication year field' do
      expect(override_config.show_fields).to have_key('publication_year_isort_stored_single')
    end

    it 'sets the institution field' do
      expect(override_config.show_fields).to have_key('institution_a')
    end

    it 'sets the URL field' do
      expect(override_config.show_fields).to have_key('url_href_a')
    end
  end

  describe 'search fields' do
    describe 'all fields' do
      it 'sets the all fields field' do
        expect(override_config.search_fields).to have_key('all_fields')
      end

      it 'has a label' do
        expect(override_config.search_fields['all_fields'].label).to eq('All Fields')
      end
    end

    describe 'title field' do
      it 'sets the title field' do
        expect(override_config.search_fields).to have_key('title')
      end

      it 'has a label' do
        expect(override_config.search_fields['title'].label).to eq('Title')
      end
    end

    describe 'author field' do
      it 'sets the author field' do
        expect(override_config.search_fields).to have_key('author')
      end

      it 'has a label' do
        expect(override_config.search_fields['author'].label).to eq('Author')
      end
    end

    describe 'subject field' do
      it 'sets the subject field' do
        expect(override_config.search_fields).to have_key('subject')
      end

      it 'has a label' do
        expect(override_config.search_fields['subject'].label).to eq('Subject')
      end
    end
  end

  describe 'sort fields' do
    describe 'Relevance' do
      let(:fields) { 'score desc, publication_year_isort_stored_single desc, title_sort_ssort_single asc' }

      it 'sets the sort fields' do
        expect(override_config.sort_fields).to have_key(fields)
      end

      it 'sets the label' do
        expect(override_config.sort_fields[fields].label).to eq('Relevance')
      end
    end

    describe 'Year: New to Old' do
      let(:fields) { 'publication_year_isort_stored_single desc, title_sort_ssort_single asc' }

      it 'sets the sort fields' do
        expect(override_config.sort_fields).to have_key(fields)
      end

      it 'sets the label' do
        expect(override_config.sort_fields[fields].label).to eq('Year (new to old)')
      end
    end

    describe 'Title: A to Z' do
      let(:fields) { 'title_sort_ssort_single asc, publication_year_isort_stored_single asc' }

      it 'sets the sort fields' do
        expect(override_config.sort_fields).to have_key(fields)
      end

      it 'sets the label' do
        expect(override_config.sort_fields[fields].label).to eq('Title (A-Z)')
      end
    end
  end
end
