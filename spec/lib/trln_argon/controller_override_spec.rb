describe TrlnArgon::ControllerOverride do
  class ControllerOverrideTestClass < CatalogController
  end

  let(:mock_controller) { ControllerOverrideTestClass.new }
  let(:override_config) { mock_controller.blacklight_config }

  describe 'search builder' do
    it 'uses the expected search builder' do
      expect(override_config.search_builder_class).to eq(DefaultLocalSearchBuilder)
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
      expect(override_config.advanced_search[:query_parser]).to be_nil
    end

    it 'sets the form_solr_parameters' do
      expect(override_config.advanced_search[:form_solr_parameters]).to eq(
        'defType' => 'lucene',
        'facet.field' => [TrlnArgon::Fields::AVAILABLE_FACET.to_s,
                          TrlnArgon::Fields::ACCESS_TYPE_FACET.to_s,
                          TrlnArgon::Fields::RESOURCE_TYPE_FACET.to_s,
                          TrlnArgon::Fields::LANGUAGE_FACET.to_s],
        'f.resource_type_f.facet.limit' => -1,
        'f.language_f.facet.limit' => -1,
        'facet.limit' => -1,
        'facet.sort' => 'index',
        'facet.query' => ''
      )
    end
  end

  describe 'autosuggest configuration' do
    it 'turns on autosuggest' do
      expect(override_config.autocomplete_enabled).to be true
    end

    it 'sets the name of the Solr suggest component' do
      expect(override_config.autocomplete_solr_component).to eq('suggest')
    end

    it 'sets the request handler for all_fields suggestions' do
      expect(override_config.autocomplete_path).to eq('suggest')
    end

    it 'sets the request handler for title suggestions' do
      expect(override_config.autocomplete_path_title).to eq('suggest_title')
    end

    it 'sets the request handler for author suggestions' do
      expect(override_config.autocomplete_path_author).to eq('suggest_author')
    end

    it 'sets the requst handler for subject suggestions' do
      expect(override_config.autocomplete_path_subject).to eq('suggest_subject')
    end
  end

  describe 'show document actions' do
    it 'sets the RIS show document action' do
      expect(override_config.show.document_actions).to include(:ris)
    end

    it 'sets the Argon Refworks show document action' do
      expect(override_config.show.document_actions).to include(:refworks)
    end

    it 'sets the email show document action' do
      expect(override_config.show.document_actions).to include(:email)
    end

    it 'sets the sms show document action' do
      expect(override_config.show.document_actions).to include(:sms)
    end

    it 'sets the share bookmarks show document action' do
      expect(override_config.show.document_actions).to include(:share_bookmarks)
    end
  end

  describe 'title field' do
    it 'sets the title field' do
      expect(override_config.index.title_field).to eq('title_main')
    end
  end

  describe 'display type field' do
    it 'sets the display type field' do
      expect(override_config.index.display_type_field).to eq('resource_type_a')
    end
  end

  describe 'facet fields' do
    it 'sets the resource type facet' do
      expect(override_config.facet_fields).to have_key('resource_type_f')
    end

    it 'sets the physical media facet' do
      expect(override_config.facet_fields).to have_key('physical_media_f')
    end

    it 'sets the subject topic lcsh facet' do
      expect(override_config.facet_fields).to have_key('subject_topical_f')
    end

    it 'sets the subject genre facet' do
      expect(override_config.facet_fields).to have_key('subject_genre_f')
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
      expect(override_config.facet_fields).to have_key('publication_year_isort')
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

    it 'sets the location hierarchy facet counts to exclude rollup' do
      expect(override_config.facet_fields['location_hierarchy_f'][:ex]).to eq(:rollup)
    end

    it 'sets the availability facet' do
      expect(override_config.facet_fields).to have_key('available_f')
    end
  end

  describe 'home facet fields' do
    it 'sets the resource type facet' do
      expect(override_config.home_facet_fields).to have_key('resource_type_f')
    end

    it 'sets the language facet' do
      expect(override_config.home_facet_fields).to have_key('language_f')
    end

    it 'sets the call number facet' do
      expect(override_config.home_facet_fields).to have_key('lcc_callnum_classification_f')
    end

    it 'sets the location hierarchy facet' do
      expect(override_config.home_facet_fields).to have_key('location_hierarchy_f')
    end

    it 'sets the location hierarchy facet counts to exclude rollup' do
      expect(override_config.facet_fields['location_hierarchy_f'][:ex]).to eq(:rollup)
    end

    it 'sets the availability facet' do
      expect(override_config.home_facet_fields).to have_key('available_f')
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

    it 'sets the resource type field' do
      expect(override_config.index_fields).to have_key('resource_type_a')
    end

    it 'sets the physical media field' do
      expect(override_config.index_fields).to have_key('physical_media_a')
    end

    it 'sets the creator main field' do
      expect(override_config.index_fields).to have_key('creator_main_a')
    end

    it 'sets the debug info' do
      expect(override_config.index_fields).to have_key('id')
    end
  end

  describe 'show fields' do
    it 'sets the Variant Title field' do
      expect(override_config.show_fields).to have_key('title_variant_a')
    end

    it 'sets the Former Title field' do
      expect(override_config.show_fields).to have_key('title_former_a')
    end

    it 'sets the Current Frequency field' do
      expect(override_config.show_fields).to have_key('frequency_current_a')
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

    it 'sets the Access Restrictions Note field' do
      expect(override_config.show_fields).to have_key('note_access_restrictions_a')
    end

    it 'sets the Admin History Note field' do
      expect(override_config.show_fields).to have_key('note_admin_history_a')
    end

    it 'sets the Binding Note field' do
      expect(override_config.show_fields).to have_key('note_binding_a')
    end

    it 'sets the Biographical Note field' do
      expect(override_config.show_fields).to have_key('note_biographical_a')
    end

    it 'sets the Copy Version Note field' do
      expect(override_config.show_fields).to have_key('note_copy_version_a')
    end

    it 'sets the Data Quality Note field' do
      expect(override_config.show_fields).to have_key('note_data_quality_a')
    end

    it 'sets the Dissertation Note field' do
      expect(override_config.show_fields).to have_key('note_dissertation_a')
    end

    it 'sets the File Type Note field' do
      expect(override_config.show_fields).to have_key('note_file_type_a')
    end

    it 'sets the Issuance Note field' do
      expect(override_config.show_fields).to have_key('note_issuance_a')
    end

    it 'sets the Numbering Note field' do
      expect(override_config.show_fields).to have_key('note_numbering_a')
    end

    it 'sets the Organization Note field' do
      expect(override_config.show_fields).to have_key('note_organization_a')
    end

    it 'sets the Performer Credits Note field' do
      expect(override_config.show_fields).to have_key('note_performer_credits_a')
    end

    it 'sets the Production Credits Note field' do
      expect(override_config.show_fields).to have_key('note_production_credits_a')
    end

    it 'sets the Report Coverage Note field' do
      expect(override_config.show_fields).to have_key('note_report_coverage_a')
    end

    it 'sets the Report Type Note field' do
      expect(override_config.show_fields).to have_key('note_report_type_a')
    end

    it 'sets the Scale Note field' do
      expect(override_config.show_fields).to have_key('note_scale_a')
    end

    it 'sets the Supplement Note field' do
      expect(override_config.show_fields).to have_key('note_supplement_a')
    end

    it 'sets the System Details Note field' do
      expect(override_config.show_fields).to have_key('note_system_details_a')
    end

    it 'sets the With Note field' do
      expect(override_config.show_fields).to have_key('note_with_a')
    end

    it 'sets the Former Title Note field' do
      expect(override_config.show_fields).to have_key('note_former_title_a')
    end

    it 'sets the General Note field' do
      expect(override_config.show_fields).to have_key('note_general_a')
    end

    it 'sets the Local Note field' do
      expect(override_config.show_fields).to have_key('note_local_a')
    end

    it 'sets the Methodology Note field' do
      expect(override_config.show_fields).to have_key('note_methodology_a')
    end

    it 'sets the Related Work Note field' do
      expect(override_config.show_fields).to have_key('note_related_work_a')
    end

    it 'sets the Reproduction Note field' do
      expect(override_config.show_fields).to have_key('note_reproduction_a')
    end

    it 'sets the Misc ID field' do
      expect(override_config.show_fields).to have_key('misc_id_a')
    end

    it 'sets the UPC field' do
      expect(override_config.show_fields).to have_key('upc_a')
    end

    it 'sets the Note Serial Dates field' do
      expect(override_config.show_fields).to have_key('note_serial_dates_a')
    end

    it 'sets the Physical Description field' do
      expect(override_config.show_fields).to have_key('physical_description_a')
    end

    it 'sets the Physical Description Details field' do
      expect(override_config.show_fields).to have_key('physical_description_details_a')
    end

    it 'sets the Series Statement field' do
      expect(override_config.show_fields).to have_key('series_statement_a')
    end

    it 'sets the Genre Heading field' do
      expect(override_config.show_fields).to have_key('genre_headings_a')
    end

    it 'sets the Terms of Use field' do
      expect(override_config.show_fields).to have_key('note_use_terms_a')
    end

    it 'sets the Preferred Citation field' do
      expect(override_config.show_fields).to have_key('note_preferred_citation_a')
    end
  end

  describe 'show included works fields' do
    it 'sets the Included Works field' do
      expect(override_config.show_included_works_fields).to have_key('included_work_a')
    end
  end

  describe 'show Related Work fields' do
    it 'sets the Related Work field' do
      expect(override_config.show_related_works_fields).to have_key('related_work_a')
    end

    it 'sets the This Work field' do
      expect(override_config.show_related_works_fields).to have_key('this_work_a')
    end

    it 'sets the Series Work field' do
      expect(override_config.show_related_works_fields).to have_key('series_work_a')
    end

    it 'sets the Translation Of Work field' do
      expect(override_config.show_related_works_fields).to have_key('translation_of_work_a')
    end

    it 'sets the Translated As Work field' do
      expect(override_config.show_related_works_fields).to have_key('translated_as_work_a')
    end

    it 'sets the Has Supplement Work field' do
      expect(override_config.show_related_works_fields).to have_key('has_supplement_work_a')
    end

    it 'sets the Host Item Work field' do
      expect(override_config.show_related_works_fields).to have_key('host_item_work_a')
    end

    it 'sets the Alt Edition Work field' do
      expect(override_config.show_related_works_fields).to have_key('alt_edition_work_a')
    end

    it 'sets the Issued With Work field' do
      expect(override_config.show_related_works_fields).to have_key('issued_with_work_a')
    end

    it 'sets the Earlier Work field' do
      expect(override_config.show_related_works_fields).to have_key('earlier_work_a')
    end

    it 'sets the Later Work field' do
      expect(override_config.show_related_works_fields).to have_key('later_work_a')
    end

    it 'sets the Data Source Work field' do
      expect(override_config.show_related_works_fields).to have_key('data_source_work_a')
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

    it 'sets the Resource Type field' do
      expect(override_config.show_sub_header_fields).to have_key('resource_type_a')
    end

    it 'sets the Physical Media field' do
      expect(override_config.show_sub_header_fields).to have_key('physical_media_a')
    end

    it 'sets the creator main field' do
      expect(override_config.show_sub_header_fields).to have_key('creator_main_a')
    end

    it 'sets the debug info' do
      expect(override_config.show_sub_header_fields).to have_key('id')
    end
  end

  describe 'show author fields' do
    it 'set the Names field' do
      expect(override_config.show_authors_fields).to have_key('names_a')
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

    describe 'publisher field' do
      it 'sets the publisher field' do
        expect(override_config.search_fields).to have_key('publisher')
      end

      it 'has a label' do
        expect(override_config.search_fields['publisher'].label).to eq('Publisher')
      end
    end

    describe 'series field' do
      it 'sets the series field' do
        expect(override_config.search_fields).to have_key('series_statement')
      end

      it 'has a label' do
        expect(override_config.search_fields['series_statement'].label).to eq('Series')
      end
    end
  end

  describe 'sort fields' do
    describe 'Relevance' do
      let(:fields) { 'score desc, publication_year_isort desc, title_sort_ssort_single asc' }

      it 'sets the sort fields' do
        expect(override_config.sort_fields).to have_key(fields)
      end

      it 'sets the label' do
        expect(override_config.sort_fields[fields].label).to eq('Relevance')
      end
    end

    describe 'Year: New to Old' do
      let(:fields) { 'publication_year_isort desc, title_sort_ssort_single asc' }

      it 'sets the sort fields' do
        expect(override_config.sort_fields).to have_key(fields)
      end

      it 'sets the label' do
        expect(override_config.sort_fields[fields].label).to eq('Year (new to old)')
      end
    end

    describe 'Year: Old to New' do
      let(:fields) { 'publication_year_isort asc, title_sort_ssort_single asc' }

      it 'sets the sort fields' do
        expect(override_config.sort_fields).to have_key(fields)
      end

      it 'sets the label' do
        expect(override_config.sort_fields[fields].label).to eq('Year (old to new)')
      end
    end

    describe 'Title: A to Z' do
      let(:fields) { 'title_sort_ssort_single asc, publication_year_isort asc' }

      it 'sets the sort fields' do
        expect(override_config.sort_fields).to have_key(fields)
      end

      it 'sets the label' do
        expect(override_config.sort_fields[fields].label).to eq('Title (A-Z)')
      end
    end
  end
end
