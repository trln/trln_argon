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
      expect(override_config.advanced_search[:form_solr_parameters]).to eq(
        'facet.field' => [], 'facet.limit' => -1, 'facet.sort' => 'index'
      )
    end
  end

  describe 'show document actions' do
    it 'sets the RIS show document action' do
      expect(override_config.show.document_actions).to include(:ris)
    end

    it 'sets the Argon Refworks show document action' do
      expect(override_config.show.document_actions).to include(:argon_refworks)
    end

    it 'sets the email show document action' do
      expect(override_config.show.document_actions).to include(:email)
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

    it 'sets the subject topic lcsh facet' do
      expect(override_config.facet_fields).to have_key('subject_topic_lcsh_f')
    end

    it 'sets the subject genre facet' do
      expect(override_config.facet_fields).to have_key('subject_genre_f')
    end

    it 'sets the subject medical facet' do
      expect(override_config.facet_fields).to have_key('subject_medical_f')
    end

    it 'sets the subject geographic facet' do
      expect(override_config.facet_fields).to have_key('subject_geographic_f')
    end

    it 'sets the subject chronological facet' do
      expect(override_config.facet_fields).to have_key('subject_chronological_f')
    end

    it 'sets the authors main facet' do
      expect(override_config.facet_fields).to have_key('author_facet_f')
    end

    it 'sets the publication year facet' do
      expect(override_config.facet_fields).to have_key('publication_year_isort_stored_single')
    end

    it 'sets the language facet' do
      expect(override_config.facet_fields).to have_key('language_f')
    end

    it 'sets the call number facet' do
      expect(override_config.facet_fields).to have_key('lcc_callnum_classification_f')
    end

    it 'sets the location hierarchy facet' do
      expect(override_config.facet_fields).to have_key('location_hierarchy_f')
    end

    it 'sets the availability facet' do
      expect(override_config.facet_fields).to have_key('available_f')
    end

    it 'sets the institution facet' do
      expect(override_config.facet_fields).to have_key('institution_f')
    end
  end

  describe 'index fields' do
    it 'sets the imprint main field' do
      expect(override_config.index_fields).to have_key('imprint_main_a')
    end

    it 'sets the edition field' do
      expect(override_config.index_fields).to have_key('edition_a')
    end

    it 'sets the statement of responsibility field' do
      expect(override_config.index_fields).to have_key('statement_of_responsibility_a')
    end

    it 'sets the format field' do
      expect(override_config.index_fields).to have_key('format_a')
    end
  end

  describe 'show fields' do
    it 'sets the Uniform Title field' do
      expect(override_config.show_fields).to have_key('title_uniform_a')
    end

    it 'sets the Current Frequency field' do
      expect(override_config.show_fields).to have_key('frequency_current_a')
    end

    it 'sets the General Description field' do
      expect(override_config.show_fields).to have_key('description_general_a')
    end

    it 'sets the Volume Description field' do
      expect(override_config.show_fields).to have_key('description_volumes_a')
    end

    it 'sets the Notes field' do
      expect(override_config.show_fields).to have_key('notes_indexed_a')
    end

    it 'sets the ISBN with Qualifying Info field' do
      expect(override_config.show_fields).to have_key('isbn_with_qualifying_info')
    end

    it 'sets the ISSN field' do
      expect(override_config.show_fields).to have_key('issn_linking_a')
    end

    it 'sets the OCLC Number field' do
      expect(override_config.show_fields).to have_key('oclc_number')
    end
  end

  # fields that display below the record title on the 'show' page.
  describe 'show sub header fields' do
    it 'sets the Statement of Responsibility' do
      expect(override_config.show_sub_header_fields).to have_key('statement_of_responsibility_a')
    end

    it 'sets the Imprint field' do
      expect(override_config.show_sub_header_fields).to have_key('imprint_main_a')
    end
    it 'sets the Edition field' do
      expect(override_config.show_sub_header_fields).to have_key('edition_a')
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

  describe '#filter_scope_name' do
    context 'when the scope is BookmarksController' do
      before { allow(mock_controller).to receive(:controller_name).and_return('bookmarks') }

      it 'uses the translated scope name for bookmarks' do
        expect(mock_controller.filter_scope_name).to eq('bookmarked')
      end
    end

    context 'when local filter is applied', verify_stubs: false do
      before do
        allow(mock_controller).to receive(:controller_name).and_return('catalog')
        allow(mock_controller).to receive(:local_filter_applied?).and_return(true)
      end

      it 'uses the translated scope name for bookmarks' do
        expect(mock_controller.filter_scope_name).to eq('UNC')
      end
    end

    context 'when local filter is not applied', verify_stubs: false do
      before do
        allow(mock_controller).to receive(:controller_name).and_return('catalog')
        allow(mock_controller).to receive(:local_filter_applied?).and_return(false)
      end

      it 'uses the translated scope name for bookmarks' do
        expect(mock_controller.filter_scope_name).to eq('TRLN')
      end
    end
  end
end
