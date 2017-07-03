module TrlnArgon
  RSpec.describe Fields do

    describe "identifier field constants" do

      it "should have a ID" do
        expect(Fields::ID.label).to eq("Id")
        expect(Fields::ID.solr_name).to eq("id")
      end

      it "should have a ROLLUP_ID" do
        expect(Fields::ROLLUP_ID.label).to eq("Rollup")
        expect(Fields::ROLLUP_ID.solr_name).to eq('rollup_id')
      end

    end

    describe "display field constants" do

      it "should have a AUTHORS_DIRECTOR" do
        expect(Fields::AUTHORS_DIRECTOR.label).to eq("Authors Director")
        expect(Fields::AUTHORS_DIRECTOR.solr_name).to eq("authors_director_a")
      end

      it "should have a AUTHORS_DIRECTOR_MARC_SOURCE" do
        expect(Fields::AUTHORS_DIRECTOR_MARC_SOURCE.label).to eq("Authors Director Marc Source")
        expect(Fields::AUTHORS_DIRECTOR_MARC_SOURCE.solr_name).to eq("authors_director_marc_source_a")
      end

      it "should have a AUTHORS_MAIN" do
        expect(Fields::AUTHORS_MAIN.label).to eq("Author")
        expect(Fields::AUTHORS_MAIN.solr_name).to eq("authors_main_a")
      end

      it "should have a AUTHORS_MAIN_CJK" do
        expect(Fields::AUTHORS_MAIN_CJK.label).to eq("Authors Main Cjk")
        expect(Fields::AUTHORS_MAIN_CJK.solr_name).to eq("authors_main_cjk_v")
      end

      it "should have a AUTHORS_MAIN_MARC_SOURCE" do
        expect(Fields::AUTHORS_MAIN_MARC_SOURCE.label).to eq("Authors Main Marc Source")
        expect(Fields::AUTHORS_MAIN_MARC_SOURCE.solr_name).to eq("authors_main_marc_source_a")
      end

      it "should have a AUTHORS_MAIN_RUS" do
        expect(Fields::AUTHORS_MAIN_RUS.label).to eq("Authors Main Rus")
        expect(Fields::AUTHORS_MAIN_RUS.solr_name).to eq("authors_main_rus_v")
      end

      it "should have a AUTHORS_MAIN_VERN" do
        expect(Fields::AUTHORS_MAIN_VERN.label).to eq("Authors Main Vern")
        expect(Fields::AUTHORS_MAIN_VERN.solr_name).to eq("authors_main_vern")
      end

      it "should have a AUTHORS_MAIN_VERNACULAR_LANG" do
        expect(Fields::AUTHORS_MAIN_VERNACULAR_LANG.label).to eq("Authors Main Vernacular Lang")
        expect(Fields::AUTHORS_MAIN_VERNACULAR_LANG.solr_name).to eq("authors_main_vernacular_lang_a")
      end

      it "should have a AUTHORS_OTHER" do
        expect(Fields::AUTHORS_OTHER.label).to eq("Authors Other")
        expect(Fields::AUTHORS_OTHER.solr_name).to eq("authors_other_a")
      end

      it "should have a AUTHORS_OTHER_CJK" do
        expect(Fields::AUTHORS_OTHER_CJK.label).to eq("Authors Other Cjk")
        expect(Fields::AUTHORS_OTHER_CJK.solr_name).to eq("authors_other_cjk_v")
      end

      it "should have a AUTHORS_OTHER_MARC_SOURCE" do
        expect(Fields::AUTHORS_OTHER_MARC_SOURCE.label).to eq("Authors Other Marc Source")
        expect(Fields::AUTHORS_OTHER_MARC_SOURCE.solr_name).to eq("authors_other_marc_source_a")
      end

      it "should have a AUTHORS_OTHER_RUS" do
        expect(Fields::AUTHORS_OTHER_RUS.label).to eq("Authors Other Rus")
        expect(Fields::AUTHORS_OTHER_RUS.solr_name).to eq("authors_other_rus_v")
      end

      it "should have a AUTHORS_OTHER_VERN" do
        expect(Fields::AUTHORS_OTHER_VERN.label).to eq("Authors Other Vern")
        expect(Fields::AUTHORS_OTHER_VERN.solr_name).to eq("authors_other_vern")
      end

      it "should have a AUTHORS_OTHER_VERNACULAR_LANG" do
        expect(Fields::AUTHORS_OTHER_VERNACULAR_LANG.label).to eq("Authors Other Vernacular Lang")
        expect(Fields::AUTHORS_OTHER_VERNACULAR_LANG.solr_name).to eq("authors_other_vernacular_lang_a")
      end

      it "should have a AUTHORS_UNCONTROLLED" do
        expect(Fields::AUTHORS_UNCONTROLLED.label).to eq("Authors Uncontrolled")
        expect(Fields::AUTHORS_UNCONTROLLED.solr_name).to eq("authors_uncontrolled_a")
      end

      it "should have a AUTHORS_UNCONTROLLED_MARC_SOURCE" do
        expect(Fields::AUTHORS_UNCONTROLLED_MARC_SOURCE.label).to eq("Authors Uncontrolled Marc Source")
        expect(Fields::AUTHORS_UNCONTROLLED_MARC_SOURCE.solr_name).to eq("authors_uncontrolled_marc_source_a")
      end

      it "should have a CARTOGRAPHIC_DATA" do
        expect(Fields::CARTOGRAPHIC_DATA.label).to eq("Cartographic Data")
        expect(Fields::CARTOGRAPHIC_DATA.solr_name).to eq("cartographic_data_a")
      end

      it "should have a CHARACTERISTICS_DIGITAL_FILE" do
        expect(Fields::CHARACTERISTICS_DIGITAL_FILE.label).to eq("Characteristics Digital File")
        expect(Fields::CHARACTERISTICS_DIGITAL_FILE.solr_name).to eq("characteristics_digital_file_a")
      end

      it "should have a CHARACTERISTICS_PROJECTION" do
        expect(Fields::CHARACTERISTICS_PROJECTION.label).to eq("Characteristics Projection")
        expect(Fields::CHARACTERISTICS_PROJECTION.solr_name).to eq("characteristics_projection_a")
      end

      it "should have a CHARACTERISTICS_SOUND" do
        expect(Fields::CHARACTERISTICS_SOUND.label).to eq("Characteristics Sound")
        expect(Fields::CHARACTERISTICS_SOUND.solr_name).to eq("characteristics_sound_a")
      end

      it "should have a CHARACTERISTICS_VIDEO" do
        expect(Fields::CHARACTERISTICS_VIDEO.label).to eq("Characteristics Video")
        expect(Fields::CHARACTERISTICS_VIDEO.solr_name).to eq("characteristics_video_a")
      end

      it "should have a COLLECTION" do
        expect(Fields::COLLECTION.label).to eq("Collection")
        expect(Fields::COLLECTION.solr_name).to eq("collection_a")
      end

      it "should have a COPYRIGHT" do
        expect(Fields::COPYRIGHT.label).to eq("Copyright")
        expect(Fields::COPYRIGHT.solr_name).to eq("copyright_a")
      end

      it "should have a COPYRIGHT_STATEMENT" do
        expect(Fields::COPYRIGHT_STATEMENT.label).to eq("Copyright Statement")
        expect(Fields::COPYRIGHT_STATEMENT.solr_name).to eq("copyright_statement_a")
      end

      it "should have a COPYRIGHT_YEAR" do
        expect(Fields::COPYRIGHT_YEAR.label).to eq("Copyright Year")
        expect(Fields::COPYRIGHT_YEAR.solr_name).to eq("copyright_year_a")
      end

      it "should have a COPYRIGHT_YEAR_I" do
        expect(Fields::COPYRIGHT_YEAR_I.label).to eq("Copyright Year I")
        expect(Fields::COPYRIGHT_YEAR_I.solr_name).to eq("copyright_year_i")
      end

      it "should have a DESCRIPTION_DIGITAL_FILE" do
        expect(Fields::DESCRIPTION_DIGITAL_FILE.label).to eq("Description Digital File")
        expect(Fields::DESCRIPTION_DIGITAL_FILE.solr_name).to eq("description_digital_file_a")
      end

      it "should have a DESCRIPTION_GENERAL" do
        expect(Fields::DESCRIPTION_GENERAL.label).to eq("Description General")
        expect(Fields::DESCRIPTION_GENERAL.solr_name).to eq("description_general_a")
      end

      it "should have a DESCRIPTION_ORGANIZATION" do
        expect(Fields::DESCRIPTION_ORGANIZATION.label).to eq("Description Organization")
        expect(Fields::DESCRIPTION_ORGANIZATION.solr_name).to eq("description_organization_a")
      end

      it "should have a DESCRIPTION_PROJECTION" do
        expect(Fields::DESCRIPTION_PROJECTION.label).to eq("Description Projection")
        expect(Fields::DESCRIPTION_PROJECTION.solr_name).to eq("description_projection_a")
      end

      it "should have a DESCRIPTION_SOUND" do
        expect(Fields::DESCRIPTION_SOUND.label).to eq("Description Sound")
        expect(Fields::DESCRIPTION_SOUND.solr_name).to eq("description_sound_a")
      end

      it "should have a DESCRIPTION_VIDEO" do
        expect(Fields::DESCRIPTION_VIDEO.label).to eq("Description Video")
        expect(Fields::DESCRIPTION_VIDEO.solr_name).to eq("description_video_a")
      end

      it "should have a DESCRIPTION_VOLUMES" do
        expect(Fields::DESCRIPTION_VOLUMES.label).to eq("Description Volumes")
        expect(Fields::DESCRIPTION_VOLUMES.solr_name).to eq("description_volumes_a")
      end

      it "should have a DISTRIBUTION_STATEMENT" do
        expect(Fields::DISTRIBUTION_STATEMENT.label).to eq("Distribution Statement")
        expect(Fields::DISTRIBUTION_STATEMENT.solr_name).to eq("distribution_statement_a")
      end

      it "should have a DISTRIBUTOR" do
        expect(Fields::DISTRIBUTOR.label).to eq("Distributor")
        expect(Fields::DISTRIBUTOR.solr_name).to eq("distributor_a")
      end

      it "should have a EDITION" do
        expect(Fields::EDITION.label).to eq("Edition")
        expect(Fields::EDITION.solr_name).to eq("edition_a")
      end

      it "should have a EDITION_CJK" do
        expect(Fields::EDITION_CJK.label).to eq("Edition Cjk")
        expect(Fields::EDITION_CJK.solr_name).to eq("edition_cjk_v")
      end

      it "should have a EDITION_VERN" do
        expect(Fields::EDITION_VERN.label).to eq("Edition Vern")
        expect(Fields::EDITION_VERN.solr_name).to eq("edition_vern")
      end

      it "should have a EDITION_VERNACULAR_LANG" do
        expect(Fields::EDITION_VERNACULAR_LANG.label).to eq("Edition Vernacular Lang")
        expect(Fields::EDITION_VERNACULAR_LANG.solr_name).to eq("edition_vernacular_lang_a")
      end

      it "should have a FORMAT" do
        expect(Fields::FORMAT.label).to eq("Format")
        expect(Fields::FORMAT.solr_name).to eq("format_a")
      end

      it "should have a FREQUENCY_CURRENT" do
        expect(Fields::FREQUENCY_CURRENT.label).to eq("Frequency Current")
        expect(Fields::FREQUENCY_CURRENT.solr_name).to eq("frequency_current_a")
      end

      it "should have a FREQUENCY_FORMER" do
        expect(Fields::FREQUENCY_FORMER.label).to eq("Frequency Former")
        expect(Fields::FREQUENCY_FORMER.solr_name).to eq("frequency_former_a")
      end

      it "should have a IMPRINT" do
        expect(Fields::IMPRINT.label).to eq("Imprint")
        expect(Fields::IMPRINT.solr_name).to eq("imprint_a")
      end

      it "should have a IMPRINT_TYPE" do
        expect(Fields::IMPRINT_TYPE.label).to eq("Imprint Type")
        expect(Fields::IMPRINT_TYPE.solr_name).to eq("imprint_type_a")
      end

      it "should have a INSTITUTION" do
        expect(Fields::INSTITUTION.label).to eq("Institution")
        expect(Fields::INSTITUTION.solr_name).to eq("institution_a")
      end

      it "should have a ISBN" do
        expect(Fields::ISBN.label).to eq("Isbn")
        expect(Fields::ISBN.solr_name).to eq("isbn_a")
      end

      it "should have a ISBN_NUMBER" do
        expect(Fields::ISBN_NUMBER.label).to eq("ISBN Number")
        expect(Fields::ISBN_NUMBER.solr_name).to eq("isbn_number_a")
      end

      it "should have a ISBN_NUMBER_ISBN" do
        expect(Fields::ISBN_NUMBER_ISBN.label).to eq("Isbn Number Isbn")
        expect(Fields::ISBN_NUMBER_ISBN.solr_name).to eq("isbn_number_isbn")
      end

      it "should have a ISBN_QUALIFYING_INFO" do
        expect(Fields::ISBN_QUALIFYING_INFO.label).to eq("Isbn Qualifying Info")
        expect(Fields::ISBN_QUALIFYING_INFO.solr_name).to eq("isbn_qualifying_info_a")
      end

      it "should have a ISSN" do
        expect(Fields::ISSN.label).to eq("Issn")
        expect(Fields::ISSN.solr_name).to eq("issn_a")
      end

      it "should have a ISSN_LINKING" do
        expect(Fields::ISSN_LINKING.label).to eq("Issn Linking")
        expect(Fields::ISSN_LINKING.solr_name).to eq("issn_linking_a")
      end

      it "should have a ISSN_LINKING_ISBN" do
        expect(Fields::ISSN_LINKING_ISBN.label).to eq("Issn Linking Isbn")
        expect(Fields::ISSN_LINKING_ISBN.solr_name).to eq("issn_linking_isbn")
      end

      it "should have a ISSN_PRIMARY" do
        expect(Fields::ISSN_PRIMARY.label).to eq("Issn Primary")
        expect(Fields::ISSN_PRIMARY.solr_name).to eq("issn_primary_a")
      end

      it "should have a ISSN_PRIMARY_ISBN" do
        expect(Fields::ISSN_PRIMARY_ISBN.label).to eq("Issn Primary Isbn")
        expect(Fields::ISSN_PRIMARY_ISBN.solr_name).to eq("issn_primary_isbn")
      end

      it "should have a ISSN_SERIES" do
        expect(Fields::ISSN_SERIES.label).to eq("Issn Series")
        expect(Fields::ISSN_SERIES.solr_name).to eq("issn_series_a")
      end

      it "should have a ISSN_SERIES_ISBN" do
        expect(Fields::ISSN_SERIES_ISBN.label).to eq("Issn Series Isbn")
        expect(Fields::ISSN_SERIES_ISBN.solr_name).to eq("issn_series_isbn")
      end

      it "should have a ITEMS_BARCODE" do
        expect(Fields::ITEMS_BARCODE.label).to eq("Items Barcode")
        expect(Fields::ITEMS_BARCODE.solr_name).to eq("items_barcode_a")
      end

      it "should have a ITEMS_CALL_NUMBER" do
        expect(Fields::ITEMS_CALL_NUMBER.label).to eq("Items Call Number")
        expect(Fields::ITEMS_CALL_NUMBER.solr_name).to eq("items_call_number_a")
      end

      it "should have a ITEMS_CALL_NUMBER_LCCN" do
        expect(Fields::ITEMS_CALL_NUMBER_LCCN.label).to eq("Items Call Number Lccn")
        expect(Fields::ITEMS_CALL_NUMBER_LCCN.solr_name).to eq("items_call_number_lccn")
      end

      it "should have a ITEMS_CALL_NUMBER_SCHEME" do
        expect(Fields::ITEMS_CALL_NUMBER_SCHEME.label).to eq("Items Call Number Scheme")
        expect(Fields::ITEMS_CALL_NUMBER_SCHEME.solr_name).to eq("items_call_number_scheme_a")
      end

      it "should have a ITEMS_CHECKOUTS" do
        expect(Fields::ITEMS_CHECKOUTS.label).to eq("Items Checkouts")
        expect(Fields::ITEMS_CHECKOUTS.solr_name).to eq("items_checkouts_a")
      end

      it "should have a ITEMS_COPY_NUMBER" do
        expect(Fields::ITEMS_COPY_NUMBER.label).to eq("Items Copy Number")
        expect(Fields::ITEMS_COPY_NUMBER.solr_name).to eq("items_copy_number_a")
      end

      it "should have a ITEMS_DUE_DATE" do
        expect(Fields::ITEMS_DUE_DATE.label).to eq("Items Due Date")
        expect(Fields::ITEMS_DUE_DATE.solr_name).to eq("items_due_date_a")
      end

      it "should have a ITEMS_ILS_ID" do
        expect(Fields::ITEMS_ILS_ID.label).to eq("Items Ils")
        expect(Fields::ITEMS_ILS_ID.solr_name).to eq("items_ils_id_a")
      end

      it "should have a ITEMS_ILS_NUMBER" do
        expect(Fields::ITEMS_ILS_NUMBER.label).to eq("Items Ils Number")
        expect(Fields::ITEMS_ILS_NUMBER.solr_name).to eq("items_ils_number_a")
      end

      it "should have a ITEMS_LCC_TOP" do
        expect(Fields::ITEMS_LCC_TOP.label).to eq("Items Lcc Top")
        expect(Fields::ITEMS_LCC_TOP.solr_name).to eq("items_lcc_top_a")
      end

      it "should have a ITEMS_LOCATION" do
        expect(Fields::ITEMS_LOCATION.label).to eq("Items Location")
        expect(Fields::ITEMS_LOCATION.solr_name).to eq("items_location_a")
      end

      it "should have a ITEMS_NOTE" do
        expect(Fields::ITEMS_NOTE.label).to eq("Items Note")
        expect(Fields::ITEMS_NOTE.solr_name).to eq("items_note_a")
      end

      it "should have a ITEMS_STATUS" do
        expect(Fields::ITEMS_STATUS.label).to eq("Items Status")
        expect(Fields::ITEMS_STATUS.solr_name).to eq("items_status_a")
      end

      it "should have a ITEMS_TYPE" do
        expect(Fields::ITEMS_TYPE.label).to eq("Items Type")
        expect(Fields::ITEMS_TYPE.solr_name).to eq("items_type_a")
      end

      it "should have a ITEMS_VOLUME" do
        expect(Fields::ITEMS_VOLUME.label).to eq("Items Volume")
        expect(Fields::ITEMS_VOLUME.solr_name).to eq("items_volume_a")
      end

      it "should have a LANG_CODE" do
        expect(Fields::LANG_CODE.label).to eq("Lang Code")
        expect(Fields::LANG_CODE.solr_name).to eq("lang_code_a")
      end

      it "should have a LANGUAGE" do
        expect(Fields::LANGUAGE.label).to eq("Language")
        expect(Fields::LANGUAGE.solr_name).to eq("language_a")
      end

      it "should have a LINKING_ADDED_ENTRY" do
        expect(Fields::LINKING_ADDED_ENTRY.label).to eq("Linking Added Entry")
        expect(Fields::LINKING_ADDED_ENTRY.solr_name).to eq("linking_added_entry_a")
      end

      it "should have a LINKING_HAS_SUPPLEMENT" do
        expect(Fields::LINKING_HAS_SUPPLEMENT.label).to eq("Linking Has Supplement")
        expect(Fields::LINKING_HAS_SUPPLEMENT.solr_name).to eq("linking_has_supplement_a")
      end

      it "should have a LINKING_HAS_SUPPLEMENT_ISN" do
        expect(Fields::LINKING_HAS_SUPPLEMENT_ISN.label).to eq("Linking Has Supplement Isn")
        expect(Fields::LINKING_HAS_SUPPLEMENT_ISN.solr_name).to eq("linking_has_supplement_isn_a")
      end

      it "should have a LINKING_HOST_ITEM" do
        expect(Fields::LINKING_HOST_ITEM.label).to eq("Linking Host Item")
        expect(Fields::LINKING_HOST_ITEM.solr_name).to eq("linking_host_item_a")
      end

      it "should have a LINKING_HOST_ITEM_TITLE" do
        expect(Fields::LINKING_HOST_ITEM_TITLE.label).to eq("Linking Host Item Title")
        expect(Fields::LINKING_HOST_ITEM_TITLE.solr_name).to eq("linking_host_item_title_a")
      end

      it "should have a LINKING_ISN" do
        expect(Fields::LINKING_ISN.label).to eq("Linking Isn")
        expect(Fields::LINKING_ISN.solr_name).to eq("linking_isn_a")
      end

      it "should have a LINKING_MAIN_SERIES" do
        expect(Fields::LINKING_MAIN_SERIES.label).to eq("Linking Main Series")
        expect(Fields::LINKING_MAIN_SERIES.solr_name).to eq("linking_main_series_a")
      end

      it "should have a LINKING_SUPPLEMENT_TO" do
        expect(Fields::LINKING_SUPPLEMENT_TO.label).to eq("Linking Supplement To")
        expect(Fields::LINKING_SUPPLEMENT_TO.solr_name).to eq("linking_supplement_to_a")
      end

      it "should have a LINKING_SUPPLEMENT_TO_ISN" do
        expect(Fields::LINKING_SUPPLEMENT_TO_ISN.label).to eq("Linking Supplement To Isn")
        expect(Fields::LINKING_SUPPLEMENT_TO_ISN.solr_name).to eq("linking_supplement_to_isn_a")
      end

      it "should have a LINKING_TRANSLATED_AS_TITLE" do
        expect(Fields::LINKING_TRANSLATED_AS_TITLE.label).to eq("Linking Translated As Title")
        expect(Fields::LINKING_TRANSLATED_AS_TITLE.solr_name).to eq("linking_translated_as_title_a")
      end

      it "should have a LINKING_TRANSLATION_OF" do
        expect(Fields::LINKING_TRANSLATION_OF.label).to eq("Linking Translation Of")
        expect(Fields::LINKING_TRANSLATION_OF.solr_name).to eq("linking_translation_of_a")
      end

      it "should have a LINKING_TRANSLATION_OF_TITLE" do
        expect(Fields::LINKING_TRANSLATION_OF_TITLE.label).to eq("Linking Translation Of Title")
        expect(Fields::LINKING_TRANSLATION_OF_TITLE.solr_name).to eq("linking_translation_of_title_a")
      end

      it "should have a LINKINT_SUPPLEMENT_TO" do
        expect(Fields::LINKINT_SUPPLEMENT_TO.label).to eq("Linkint Supplement To")
        expect(Fields::LINKINT_SUPPLEMENT_TO.solr_name).to eq("linkint_supplement_to_a")
      end

      it "should have a LOCAL_ID" do
        expect(Fields::LOCAL_ID.label).to eq("Local")
        expect(Fields::LOCAL_ID.solr_name).to eq("local_id")
      end

      it "should have a MANUFACTURER" do
        expect(Fields::MANUFACTURER.label).to eq("Manufacturer")
        expect(Fields::MANUFACTURER.solr_name).to eq("manufacturer_a")
      end

      it "should have a MANUFACTURER_STATEMENT" do
        expect(Fields::MANUFACTURER_STATEMENT.label).to eq("Manufacturer Statement")
        expect(Fields::MANUFACTURER_STATEMENT.solr_name).to eq("manufacturer_statement_a")
      end

      it "should have a NOTES_ADDITIONAL" do
        expect(Fields::NOTES_ADDITIONAL.label).to eq("Notes Additional")
        expect(Fields::NOTES_ADDITIONAL.solr_name).to eq("notes_additional_a")
      end

      it "should have a NOTES_ADDITIONAL_VERNACULAR_LANG" do
        expect(Fields::NOTES_ADDITIONAL_VERNACULAR_LANG.label).to eq("Notes Additional Vernacular Lang")
        expect(Fields::NOTES_ADDITIONAL_VERNACULAR_LANG.solr_name).to eq("notes_additional_vernacular_lang_a")
      end

      it "should have a NOTES_INDEXED" do
        expect(Fields::NOTES_INDEXED.label).to eq("Notes Indexed")
        expect(Fields::NOTES_INDEXED.solr_name).to eq("notes_indexed_a")
      end

      it "should have a NOTES_INDEXED_CJK" do
        expect(Fields::NOTES_INDEXED_CJK.label).to eq("Notes Indexed Cjk")
        expect(Fields::NOTES_INDEXED_CJK.solr_name).to eq("notes_indexed_cjk_v")
      end

      it "should have a NOTES_INDEXED_RUS" do
        expect(Fields::NOTES_INDEXED_RUS.label).to eq("Notes Indexed Rus")
        expect(Fields::NOTES_INDEXED_RUS.solr_name).to eq("notes_indexed_rus_v")
      end

      it "should have a NOTES_INDEXED_VERN" do
        expect(Fields::NOTES_INDEXED_VERN.label).to eq("Notes Indexed Vern")
        expect(Fields::NOTES_INDEXED_VERN.solr_name).to eq("notes_indexed_vern")
      end

      it "should have a NOTES_INDEXED_VERNACULAR_LANG" do
        expect(Fields::NOTES_INDEXED_VERNACULAR_LANG.label).to eq("Notes Indexed Vernacular Lang")
        expect(Fields::NOTES_INDEXED_VERNACULAR_LANG.solr_name).to eq("notes_indexed_vernacular_lang_a")
      end

      it "should have a OCLC_NUMBER" do
        expect(Fields::OCLC_NUMBER.label).to eq("Oclc Number")
        expect(Fields::OCLC_NUMBER.solr_name).to eq("oclc_number")
      end

      it "should have a OCLC_NUMBER_OLD" do
        expect(Fields::OCLC_NUMBER_OLD.label).to eq("Oclc Number Old")
        expect(Fields::OCLC_NUMBER_OLD.solr_name).to eq("oclc_number_old_a")
      end

      it "should have a ORGANIZATION_ARRANGEMENT" do
        expect(Fields::ORGANIZATION_ARRANGEMENT.label).to eq("Organization Arrangement")
        expect(Fields::ORGANIZATION_ARRANGEMENT.solr_name).to eq("organization_arrangement_a")
      end

      it "should have a OWNER" do
        expect(Fields::OWNER.label).to eq("Owner")
        expect(Fields::OWNER.solr_name).to eq("owner_a")
      end

      it "should have a PRODUCER" do
        expect(Fields::PRODUCER.label).to eq("Producer")
        expect(Fields::PRODUCER.solr_name).to eq("producer_a")
      end

      it "should have a PRODUCTION_STATEMENT" do
        expect(Fields::PRODUCTION_STATEMENT.label).to eq("Production Statement")
        expect(Fields::PRODUCTION_STATEMENT.solr_name).to eq("production_statement_a")
      end

      it "should have a PUBLISHER" do
        expect(Fields::PUBLISHER.label).to eq("Publisher")
        expect(Fields::PUBLISHER.solr_name).to eq("publisher_a")
      end

      it "should have a PUBLISHER_ETC" do
        expect(Fields::PUBLISHER_ETC.label).to eq("Publisher Etc")
        expect(Fields::PUBLISHER_ETC.solr_name).to eq("publisher_etc_a")
      end

      it "should have a PUBLISHER_ETC_TYPE" do
        expect(Fields::PUBLISHER_ETC_TYPE.label).to eq("Publisher Etc Type")
        expect(Fields::PUBLISHER_ETC_TYPE.solr_name).to eq("publisher_etc_type_a")
      end

      it "should have a PUBLISHER_IMPRINT" do
        expect(Fields::PUBLISHER_IMPRINT.label).to eq("Publisher Imprint")
        expect(Fields::PUBLISHER_IMPRINT.solr_name).to eq("publisher_imprint_a")
      end

      it "should have a PUBLISHER_MARC_SOURCE" do
        expect(Fields::PUBLISHER_MARC_SOURCE.label).to eq("Publisher Marc Source")
        expect(Fields::PUBLISHER_MARC_SOURCE.solr_name).to eq("publisher_marc_source_a")
      end

      it "should have a PUBLISHER_NUMBER" do
        expect(Fields::PUBLISHER_NUMBER.label).to eq("Publisher Number")
        expect(Fields::PUBLISHER_NUMBER.solr_name).to eq("publisher_number_a")
      end

      it "should have a PUBLISHER_VERNACULAR_LANG" do
        expect(Fields::PUBLISHER_VERNACULAR_LANG.label).to eq("Publisher Vernacular Lang")
        expect(Fields::PUBLISHER_VERNACULAR_LANG.solr_name).to eq("publisher_vernacular_lang_a")
      end

      it "should have a SERIES" do
        expect(Fields::SERIES.label).to eq("Series")
        expect(Fields::SERIES.solr_name).to eq("series_a")
      end

      it "should have a SERIES_DIGITAL_FILE" do
        expect(Fields::SERIES_DIGITAL_FILE.label).to eq("Series Digital File")
        expect(Fields::SERIES_DIGITAL_FILE.solr_name).to eq("series_digital_file_a")
      end

      it "should have a SERIES_GENERAL" do
        expect(Fields::SERIES_GENERAL.label).to eq("Series General")
        expect(Fields::SERIES_GENERAL.solr_name).to eq("series_general_a")
      end

      it "should have a SERIES_ORGANIZATION" do
        expect(Fields::SERIES_ORGANIZATION.label).to eq("Series Organization")
        expect(Fields::SERIES_ORGANIZATION.solr_name).to eq("series_organization_a")
      end

      it "should have a SERIES_PROJECTION" do
        expect(Fields::SERIES_PROJECTION.label).to eq("Series Projection")
        expect(Fields::SERIES_PROJECTION.solr_name).to eq("series_projection_a")
      end

      it "should have a SERIES_SOUND" do
        expect(Fields::SERIES_SOUND.label).to eq("Series Sound")
        expect(Fields::SERIES_SOUND.solr_name).to eq("series_sound_a")
      end

      it "should have a SERIES_STATEMENT" do
        expect(Fields::SERIES_STATEMENT.label).to eq("Series Statement")
        expect(Fields::SERIES_STATEMENT.solr_name).to eq("series_statement_a")
      end

      it "should have a SERIES_STATEMENT_VERNACULAR_LANG" do
        expect(Fields::SERIES_STATEMENT_VERNACULAR_LANG.label).to eq("Series Statement Vernacular Lang")
        expect(Fields::SERIES_STATEMENT_VERNACULAR_LANG.solr_name).to eq("series_statement_vernacular_lang_a")
      end

      it "should have a SERIES_TITLE_INDEX" do
        expect(Fields::SERIES_TITLE_INDEX.label).to eq("Series Title Index")
        expect(Fields::SERIES_TITLE_INDEX.solr_name).to eq("series_title_index_a")
      end

      it "should have a SERIES_VIDEO" do
        expect(Fields::SERIES_VIDEO.label).to eq("Series Video")
        expect(Fields::SERIES_VIDEO.solr_name).to eq("series_video_a")
      end

      it "should have a SERIES_VOLUMES" do
        expect(Fields::SERIES_VOLUMES.label).to eq("Series Volumes")
        expect(Fields::SERIES_VOLUMES.solr_name).to eq("series_volumes_a")
      end

      it "should have a SOURCE" do
        expect(Fields::SOURCE.label).to eq("Source")
        expect(Fields::SOURCE.solr_name).to eq("source_a")
      end

      it "should have a STATEMENT_OF_RESPONSIBILITY" do
        expect(Fields::STATEMENT_OF_RESPONSIBILITY.label).to eq("Statement Of Responsibility")
        expect(Fields::STATEMENT_OF_RESPONSIBILITY.solr_name).to eq("statement_of_responsibility_a")
      end

      it "should have a STATEMENT_OF_RESPONSIBILITY_CJK" do
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_CJK.label).to eq("Statement Of Responsibility Cjk")
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_CJK.solr_name).to eq("statement_of_responsibility_cjk_v")
      end

      it "should have a STATEMENT_OF_RESPONSIBILITY_RUS" do
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_RUS.label).to eq("Statement Of Responsibility Rus")
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_RUS.solr_name).to eq("statement_of_responsibility_rus_v")
      end

      it "should have a STATEMENT_OF_RESPONSIBILITY_VERN" do
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_VERN.label).to eq("Statement Of Responsibility Vern")
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_VERN.solr_name).to eq("statement_of_responsibility_vern")
      end

      it "should have a STATEMENT_OF_RESPONSIBILITY_VERNACULAR_LANG" do
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_VERNACULAR_LANG.label).to eq("Statement Of Responsibility Vernacular Lang")
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_VERNACULAR_LANG.solr_name).to eq("statement_of_responsibility_vernacular_lang_a")
      end

      it "should have a SUBJECTS" do
        expect(Fields::SUBJECTS.label).to eq("Subjects")
        expect(Fields::SUBJECTS.solr_name).to eq("subjects_a")
      end

      it "should have a SYNDETICS_ID" do
        expect(Fields::SYNDETICS_ID.label).to eq("Syndetics")
        expect(Fields::SYNDETICS_ID.solr_name).to eq("syndetics_id_a")
      end

      it "should have a SYNDETICS_ISBN" do
        expect(Fields::SYNDETICS_ISBN.label).to eq("Syndetics Isbn")
        expect(Fields::SYNDETICS_ISBN.solr_name).to eq("syndetics_isbn_a")
      end

      it "should have a TITLE_ABBREVIATION" do
        expect(Fields::TITLE_ABBREVIATION.label).to eq("Title Abbreviation")
        expect(Fields::TITLE_ABBREVIATION.solr_name).to eq("title_abbreviation_a")
      end

      it "should have a TITLE_ABBRV" do
        expect(Fields::TITLE_ABBRV.label).to eq("Title Abbrv")
        expect(Fields::TITLE_ABBRV.solr_name).to eq("title_abbrv_a")
      end

      it "should have a TITLE_ALT" do
        expect(Fields::TITLE_ALT.label).to eq("Title Alt")
        expect(Fields::TITLE_ALT.solr_name).to eq("title_alt_a")
      end

      it "should have a TITLE_ALT_VERNACULAR_LANG" do
        expect(Fields::TITLE_ALT_VERNACULAR_LANG.label).to eq("Title Alt Vernacular Lang")
        expect(Fields::TITLE_ALT_VERNACULAR_LANG.solr_name).to eq("title_alt_vernacular_lang_a")
      end

      it "should have a TITLE_ALTERNATE" do
        expect(Fields::TITLE_ALTERNATE.label).to eq("Title Alternate")
        expect(Fields::TITLE_ALTERNATE.solr_name).to eq("title_alternate_a")
      end

      it "should have a TITLE_ANALYTICAL" do
        expect(Fields::TITLE_ANALYTICAL.label).to eq("Title Analytical")
        expect(Fields::TITLE_ANALYTICAL.solr_name).to eq("title_analytical_a")
      end

      it "should have a TITLE_EARLIER" do
        expect(Fields::TITLE_EARLIER.label).to eq("Title Earlier")
        expect(Fields::TITLE_EARLIER.solr_name).to eq("title_earlier_a")
      end

      it "should have a TITLE_JOURNAL" do
        expect(Fields::TITLE_JOURNAL.label).to eq("Title Journal")
        expect(Fields::TITLE_JOURNAL.solr_name).to eq("title_journal_a")
      end

      it "should have a TITLE_JOURNAL_CJK" do
        expect(Fields::TITLE_JOURNAL_CJK.label).to eq("Title Journal Cjk")
        expect(Fields::TITLE_JOURNAL_CJK.solr_name).to eq("title_journal_cjk_v")
      end

      it "should have a TITLE_JOURNAL_VERN" do
        expect(Fields::TITLE_JOURNAL_VERN.label).to eq("Title Journal Vern")
        expect(Fields::TITLE_JOURNAL_VERN.solr_name).to eq("title_journal_vern")
      end

      it "should have a TITLE_JOURNAL_VERNACULAR_LANG" do
        expect(Fields::TITLE_JOURNAL_VERNACULAR_LANG.label).to eq("Title Journal Vernacular Lang")
        expect(Fields::TITLE_JOURNAL_VERNACULAR_LANG.solr_name).to eq("title_journal_vernacular_lang_a")
      end

      it "should have a TITLE_LATER" do
        expect(Fields::TITLE_LATER.label).to eq("Title Later")
        expect(Fields::TITLE_LATER.solr_name).to eq("title_later_a")
      end

      it "should have a TITLE_MAIN" do
        expect(Fields::TITLE_MAIN.label).to eq("Title")
        expect(Fields::TITLE_MAIN.solr_name).to eq("title_main")
      end

      it "should have a TITLE_MAIN_CJK" do
        expect(Fields::TITLE_MAIN_CJK.label).to eq("Title Main Cjk")
        expect(Fields::TITLE_MAIN_CJK.solr_name).to eq("title_main_cjk_v")
      end

      it "should have a TITLE_MAIN_RUS" do
        expect(Fields::TITLE_MAIN_RUS.label).to eq("Title Main Rus")
        expect(Fields::TITLE_MAIN_RUS.solr_name).to eq("title_main_rus_v")
      end

      it "should have a TITLE_MAIN_VERN" do
        expect(Fields::TITLE_MAIN_VERN.label).to eq("Title Main Vern")
        expect(Fields::TITLE_MAIN_VERN.solr_name).to eq("title_main_vern")
      end

      it "should have a TITLE_MAIN_VERNACULAR_LANG" do
        expect(Fields::TITLE_MAIN_VERNACULAR_LANG.label).to eq("Title Main Vernacular Lang")
        expect(Fields::TITLE_MAIN_VERNACULAR_LANG.solr_name).to eq("title_main_vernacular_lang_a")
      end

      it "should have a TITLE_TRANSLATION" do
        expect(Fields::TITLE_TRANSLATION.label).to eq("Title Translation")
        expect(Fields::TITLE_TRANSLATION.solr_name).to eq("title_translation_a")
      end

      it "should have a TITLE_UNIFORM" do
        expect(Fields::TITLE_UNIFORM.label).to eq("Title Uniform")
        expect(Fields::TITLE_UNIFORM.solr_name).to eq("title_uniform_a")
      end

      it "should have a UPC" do
        expect(Fields::UPC.label).to eq("Upc")
        expect(Fields::UPC.solr_name).to eq("upc_a")
      end

      it "should have a URL_HREF" do
        expect(Fields::URL_HREF.label).to eq("URL")
        expect(Fields::URL_HREF.solr_name).to eq("url_href_a")
      end

      it "should have a URL_REL" do
        expect(Fields::URL_REL.label).to eq("Url Rel")
        expect(Fields::URL_REL.solr_name).to eq("url_rel_a")
      end

      it "should have a URL_TEXT" do
        expect(Fields::URL_TEXT.label).to eq("Url Text")
        expect(Fields::URL_TEXT.solr_name).to eq("url_text_a")
      end

      it "should have a VOLUME_DATE_RANGE" do
        expect(Fields::VOLUME_DATE_RANGE.label).to eq("Volume Date Range")
        expect(Fields::VOLUME_DATE_RANGE.solr_name).to eq("volume_date_range_a")
      end

    end

    describe "facet field constants" do

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

      it "should have a ITEMS_LOCATION_FACET" do
        expect(Fields::ITEMS_LOCATION_FACET.label).to eq("Items Location")
        expect(Fields::ITEMS_LOCATION_FACET.solr_name).to eq('items_location_f')
      end

      it "should have a LANGUAGE_FACET" do
        expect(Fields::LANGUAGE_FACET.label).to eq("Language")
        expect(Fields::LANGUAGE_FACET.solr_name).to eq('language_f')
      end

      it "should have a SUBJECTS_FACET" do
        expect(Fields::SUBJECTS_FACET.label).to eq("Subjects")
        expect(Fields::SUBJECTS_FACET.solr_name).to eq('subjects_f')
      end

    end

    describe "sort field constants" do

      it "should have a AUTHORS_SORT" do
        expect(Fields::AUTHORS_SORT.label).to eq("Authors Sort")
        expect(Fields::AUTHORS_SORT.solr_name).to eq('authors_sort_a')
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