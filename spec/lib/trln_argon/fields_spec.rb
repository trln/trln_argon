module TrlnArgon
  RSpec.describe Fields do
    describe 'identifier field constants' do
      it 'has an ID label' do
        expect(Fields::ID.label).to eq('Id')
      end

      it 'has an ID solr_field' do
        expect(Fields::ID.solr_name).to eq('id')
      end

      it 'has a ROLLUP_ID label' do
        expect(Fields::ROLLUP_ID.label).to eq('Rollup')
      end

      it 'has a ROLLUP_ID solr_name' do
        expect(Fields::ROLLUP_ID.solr_name).to eq('rollup_id')
      end
    end

    describe 'display field constants' do
      it 'has a AUTHORS_DIRECTOR label' do
        expect(Fields::AUTHORS_DIRECTOR.label).to eq('Authors Director')
      end

      it 'has a AUTHORS_DIRECTOR solr name' do
        expect(Fields::AUTHORS_DIRECTOR.solr_name).to eq('authors_director_a')
      end

      it 'has a AUTHORS_DIRECTOR_MARC_SOURCE label' do
        expect(Fields::AUTHORS_DIRECTOR_MARC_SOURCE.label).to eq('Authors Director Marc Source')
      end

      it 'has a AUTHORS_DIRECTOR_MARC_SOURCE solr name' do
        expect(Fields::AUTHORS_DIRECTOR_MARC_SOURCE.solr_name).to eq('authors_director_marc_source_a')
      end

      it 'has a AUTHORS_MAIN label' do
        expect(Fields::AUTHORS_MAIN.label).to eq('Author')
      end

      it 'has a AUTHORS_MAIN solr name' do
        expect(Fields::AUTHORS_MAIN.solr_name).to eq('authors_main_a')
      end

      it 'has a AUTHORS_MAIN_CJK label' do
        expect(Fields::AUTHORS_MAIN_CJK.label).to eq('Authors Main Cjk')
      end

      it 'has a AUTHORS_MAIN_CJK solr name' do
        expect(Fields::AUTHORS_MAIN_CJK.solr_name).to eq('authors_main_cjk_v')
      end

      it 'has a AUTHORS_MAIN_MARC_SOURCE label' do
        expect(Fields::AUTHORS_MAIN_MARC_SOURCE.label).to eq('Authors Main Marc Source')
      end

      it 'has a AUTHORS_MAIN_MARC_SOURCE solr name' do
        expect(Fields::AUTHORS_MAIN_MARC_SOURCE.solr_name).to eq('authors_main_marc_source_a')
      end

      it 'has a AUTHORS_MAIN_RUS label' do
        expect(Fields::AUTHORS_MAIN_RUS.label).to eq('Authors Main Rus')
      end

      it 'has a AUTHORS_MAIN_RUS solr name' do
        expect(Fields::AUTHORS_MAIN_RUS.solr_name).to eq('authors_main_rus_v')
      end

      it 'has a AUTHORS_MAIN_VERN label' do
        expect(Fields::AUTHORS_MAIN_VERN.label).to eq('Authors Main Vern')
      end

      it 'has a AUTHORS_MAIN_VERN solr name' do
        expect(Fields::AUTHORS_MAIN_VERN.solr_name).to eq('authors_main_vern')
      end

      it 'has a AUTHORS_MAIN_VERNACULAR_LANG label' do
        expect(Fields::AUTHORS_MAIN_VERNACULAR_LANG.label).to eq('Authors Main Vernacular Lang')
      end

      it 'has a AUTHORS_MAIN_VERNACULAR_LANG solr name' do
        expect(Fields::AUTHORS_MAIN_VERNACULAR_LANG.solr_name).to eq('authors_main_vernacular_lang_a')
      end

      it 'has a AUTHORS_OTHER label' do
        expect(Fields::AUTHORS_OTHER.label).to eq('Authors Other')
      end

      it 'has a AUTHORS_OTHER solr name' do
        expect(Fields::AUTHORS_OTHER.solr_name).to eq('authors_other_a')
      end

      it 'has a AUTHORS_OTHER_CJK label' do
        expect(Fields::AUTHORS_OTHER_CJK.label).to eq('Authors Other Cjk')
      end

      it 'has a AUTHORS_OTHER_CJK solr name' do
        expect(Fields::AUTHORS_OTHER_CJK.solr_name).to eq('authors_other_cjk_v')
      end

      it 'has a AUTHORS_OTHER_MARC_SOURCE label' do
        expect(Fields::AUTHORS_OTHER_MARC_SOURCE.label).to eq('Authors Other Marc Source')
      end

      it 'has a AUTHORS_OTHER_MARC_SOURCE solr name' do
        expect(Fields::AUTHORS_OTHER_MARC_SOURCE.solr_name).to eq('authors_other_marc_source_a')
      end

      it 'has a AUTHORS_OTHER_RUS label' do
        expect(Fields::AUTHORS_OTHER_RUS.label).to eq('Authors Other Rus')
      end

      it 'has a AUTHORS_OTHER_RUS solr name' do
        expect(Fields::AUTHORS_OTHER_RUS.solr_name).to eq('authors_other_rus_v')
      end

      it 'has a AUTHORS_OTHER_VERN label' do
        expect(Fields::AUTHORS_OTHER_VERN.label).to eq('Authors Other Vern')
      end

      it 'has a AUTHORS_OTHER_VERN solr name' do
        expect(Fields::AUTHORS_OTHER_VERN.solr_name).to eq('authors_other_vern')
      end

      it 'has a AUTHORS_OTHER_VERNACULAR_LANG label' do
        expect(Fields::AUTHORS_OTHER_VERNACULAR_LANG.label).to eq('Authors Other Vernacular Lang')
      end

      it 'has a AUTHORS_OTHER_VERNACULAR_LANG solr name' do
        expect(Fields::AUTHORS_OTHER_VERNACULAR_LANG.solr_name).to eq('authors_other_vernacular_lang_a')
      end

      it 'has a AUTHORS_UNCONTROLLED label' do
        expect(Fields::AUTHORS_UNCONTROLLED.label).to eq('Authors Uncontrolled')
      end

      it 'has a AUTHORS_UNCONTROLLED solr name' do
        expect(Fields::AUTHORS_UNCONTROLLED.solr_name).to eq('authors_uncontrolled_a')
      end

      it 'has a AUTHORS_UNCONTROLLED_MARC_SOURCE label' do
        expect(Fields::AUTHORS_UNCONTROLLED_MARC_SOURCE.label).to eq('Authors Uncontrolled Marc Source')
      end

      it 'has a AUTHORS_UNCONTROLLED_MARC_SOURCE solr name' do
        expect(Fields::AUTHORS_UNCONTROLLED_MARC_SOURCE.solr_name).to eq('authors_uncontrolled_marc_source_a')
      end

      it 'has a CARTOGRAPHIC_DATA label' do
        expect(Fields::CARTOGRAPHIC_DATA.label).to eq('Cartographic Data')
      end

      it 'has a CARTOGRAPHIC_DATA solr name' do
        expect(Fields::CARTOGRAPHIC_DATA.solr_name).to eq('cartographic_data_a')
      end

      it 'has a CHARACTERISTICS_DIGITAL_FILE label' do
        expect(Fields::CHARACTERISTICS_DIGITAL_FILE.label).to eq('Characteristics Digital File')
      end

      it 'has a CHARACTERISTICS_DIGITAL_FILE solr name' do
        expect(Fields::CHARACTERISTICS_DIGITAL_FILE.solr_name).to eq('characteristics_digital_file_a')
      end

      it 'has a CHARACTERISTICS_PROJECTION label' do
        expect(Fields::CHARACTERISTICS_PROJECTION.label).to eq('Characteristics Projection')
      end

      it 'has a CHARACTERISTICS_PROJECTION solr name' do
        expect(Fields::CHARACTERISTICS_PROJECTION.solr_name).to eq('characteristics_projection_a')
      end

      it 'has a CHARACTERISTICS_SOUND label' do
        expect(Fields::CHARACTERISTICS_SOUND.label).to eq('Characteristics Sound')
      end

      it 'has a CHARACTERISTICS_SOUND solr name' do
        expect(Fields::CHARACTERISTICS_SOUND.solr_name).to eq('characteristics_sound_a')
      end

      it 'has a CHARACTERISTICS_VIDEO label' do
        expect(Fields::CHARACTERISTICS_VIDEO.label).to eq('Characteristics Video')
      end

      it 'has a CHARACTERISTICS_VIDEO solr name' do
        expect(Fields::CHARACTERISTICS_VIDEO.solr_name).to eq('characteristics_video_a')
      end

      it 'has a COLLECTION label' do
        expect(Fields::COLLECTION.label).to eq('Collection')
      end

      it 'has a COLLECTION solr name' do
        expect(Fields::COLLECTION.solr_name).to eq('collection_a')
      end

      it 'has a COPYRIGHT label' do
        expect(Fields::COPYRIGHT.label).to eq('Copyright')
      end

      it 'has a COPYRIGHT solr name' do
        expect(Fields::COPYRIGHT.solr_name).to eq('copyright_a')
      end

      it 'has a COPYRIGHT_STATEMENT label' do
        expect(Fields::COPYRIGHT_STATEMENT.label).to eq('Copyright Statement')
      end

      it 'has a COPYRIGHT_STATEMENT solr name' do
        expect(Fields::COPYRIGHT_STATEMENT.solr_name).to eq('copyright_statement_a')
      end

      it 'has a COPYRIGHT_YEAR label' do
        expect(Fields::COPYRIGHT_YEAR.label).to eq('Copyright Year')
      end

      it 'has a COPYRIGHT_YEAR solr name' do
        expect(Fields::COPYRIGHT_YEAR.solr_name).to eq('copyright_year_a')
      end

      it 'has a COPYRIGHT_YEAR_I label' do
        expect(Fields::COPYRIGHT_YEAR_I.label).to eq('Copyright Year I')
      end

      it 'has a COPYRIGHT_YEAR_I solr name' do
        expect(Fields::COPYRIGHT_YEAR_I.solr_name).to eq('copyright_year_i')
      end

      it 'has a DESCRIPTION_DIGITAL_FILE label' do
        expect(Fields::DESCRIPTION_DIGITAL_FILE.label).to eq('Description Digital File')
      end

      it 'has a DESCRIPTION_DIGITAL_FILE solr name' do
        expect(Fields::DESCRIPTION_DIGITAL_FILE.solr_name).to eq('description_digital_file_a')
      end

      it 'has a DESCRIPTION_GENERAL label' do
        expect(Fields::DESCRIPTION_GENERAL.label).to eq('Description General')
      end

      it 'has a DESCRIPTION_GENERAL solr name' do
        expect(Fields::DESCRIPTION_GENERAL.solr_name).to eq('description_general_a')
      end

      it 'has a DESCRIPTION_ORGANIZATION label' do
        expect(Fields::DESCRIPTION_ORGANIZATION.label).to eq('Description Organization')
      end

      it 'has a DESCRIPTION_ORGANIZATION solr name' do
        expect(Fields::DESCRIPTION_ORGANIZATION.solr_name).to eq('description_organization_a')
      end

      it 'has a DESCRIPTION_PROJECTION label' do
        expect(Fields::DESCRIPTION_PROJECTION.label).to eq('Description Projection')
      end

      it 'has a DESCRIPTION_PROJECTION solr name' do
        expect(Fields::DESCRIPTION_PROJECTION.solr_name).to eq('description_projection_a')
      end

      it 'has a DESCRIPTION_SOUND label' do
        expect(Fields::DESCRIPTION_SOUND.label).to eq('Description Sound')
      end

      it 'has a DESCRIPTION_SOUND solr name' do
        expect(Fields::DESCRIPTION_SOUND.solr_name).to eq('description_sound_a')
      end

      it 'has a DESCRIPTION_VIDEO label' do
        expect(Fields::DESCRIPTION_VIDEO.label).to eq('Description Video')
      end

      it 'has a DESCRIPTION_VIDEO solr name' do
        expect(Fields::DESCRIPTION_VIDEO.solr_name).to eq('description_video_a')
      end

      it 'has a DESCRIPTION_VOLUMES label' do
        expect(Fields::DESCRIPTION_VOLUMES.label).to eq('Description Volumes')
      end

      it 'has a DESCRIPTION_VOLUMES solr name' do
        expect(Fields::DESCRIPTION_VOLUMES.solr_name).to eq('description_volumes_a')
      end

      it 'has a DISTRIBUTION_STATEMENT label' do
        expect(Fields::DISTRIBUTION_STATEMENT.label).to eq('Distribution Statement')
      end

      it 'has a DISTRIBUTION_STATEMENT solr name' do
        expect(Fields::DISTRIBUTION_STATEMENT.solr_name).to eq('distribution_statement_a')
      end

      it 'has a DISTRIBUTOR label' do
        expect(Fields::DISTRIBUTOR.label).to eq('Distributor')
      end

      it 'has a DISTRIBUTOR solr name' do
        expect(Fields::DISTRIBUTOR.solr_name).to eq('distributor_a')
      end

      it 'has a EDITION label' do
        expect(Fields::EDITION.label).to eq('Edition')
      end

      it 'has a EDITION solr name' do
        expect(Fields::EDITION.solr_name).to eq('edition_a')
      end

      it 'has a EDITION_CJK label' do
        expect(Fields::EDITION_CJK.label).to eq('Edition Cjk')
      end

      it 'has a EDITION_CJK solr name' do
        expect(Fields::EDITION_CJK.solr_name).to eq('edition_cjk_v')
      end

      it 'has a EDITION_VERN label' do
        expect(Fields::EDITION_VERN.label).to eq('Edition Vern')
      end

      it 'has a EDITION_VERN solr name' do
        expect(Fields::EDITION_VERN.solr_name).to eq('edition_vern')
      end

      it 'has a EDITION_VERNACULAR_LANG label' do
        expect(Fields::EDITION_VERNACULAR_LANG.label).to eq('Edition Vernacular Lang')
      end

      it 'has a EDITION_VERNACULAR_LANG solr name' do
        expect(Fields::EDITION_VERNACULAR_LANG.solr_name).to eq('edition_vernacular_lang_a')
      end

      it 'has a FORMAT label' do
        expect(Fields::FORMAT.label).to eq('Format')
      end

      it 'has a FORMAT solr name' do
        expect(Fields::FORMAT.solr_name).to eq('format_a')
      end

      it 'has a FREQUENCY_CURRENT label' do
        expect(Fields::FREQUENCY_CURRENT.label).to eq('Frequency Current')
      end

      it 'has a FREQUENCY_CURRENT solr name' do
        expect(Fields::FREQUENCY_CURRENT.solr_name).to eq('frequency_current_a')
      end

      it 'has a FREQUENCY_FORMER label' do
        expect(Fields::FREQUENCY_FORMER.label).to eq('Frequency Former')
      end

      it 'has a FREQUENCY_FORMER solr name' do
        expect(Fields::FREQUENCY_FORMER.solr_name).to eq('frequency_former_a')
      end

      it 'has a ID label' do
        expect(Fields::ID.label).to eq('Id')
      end

      it 'has a ID solr name' do
        expect(Fields::ID.solr_name).to eq('id')
      end

      it 'has a IMPRINT label' do
        expect(Fields::IMPRINT.label).to eq('Imprint')
      end

      it 'has a IMPRINT solr name' do
        expect(Fields::IMPRINT.solr_name).to eq('imprint_a')
      end

      it 'has a IMPRINT_TYPE label' do
        expect(Fields::IMPRINT_TYPE.label).to eq('Imprint Type')
      end

      it 'has a IMPRINT_TYPE solr name' do
        expect(Fields::IMPRINT_TYPE.solr_name).to eq('imprint_type_a')
      end

      it 'has a INSTITUTION label' do
        expect(Fields::INSTITUTION.label).to eq('Institution')
      end

      it 'has a INSTITUTION solr name' do
        expect(Fields::INSTITUTION.solr_name).to eq('institution_a')
      end

      it 'has a ISBN label' do
        expect(Fields::ISBN.label).to eq('Isbn')
      end

      it 'has a ISBN solr name' do
        expect(Fields::ISBN.solr_name).to eq('isbn_a')
      end

      it 'has a ISBN_NUMBER label' do
        expect(Fields::ISBN_NUMBER.label).to eq('ISBN Number')
      end

      it 'has a ISBN_NUMBER solr name' do
        expect(Fields::ISBN_NUMBER.solr_name).to eq('isbn_number_a')
      end

      it 'has a ISBN_NUMBER_ISBN label' do
        expect(Fields::ISBN_NUMBER_ISBN.label).to eq('Isbn Number Isbn')
      end

      it 'has a ISBN_NUMBER_ISBN solr name' do
        expect(Fields::ISBN_NUMBER_ISBN.solr_name).to eq('isbn_number_isbn')
      end

      it 'has a ISBN_QUALIFYING_INFO label' do
        expect(Fields::ISBN_QUALIFYING_INFO.label).to eq('Isbn Qualifying Info')
      end

      it 'has a ISBN_QUALIFYING_INFO solr name' do
        expect(Fields::ISBN_QUALIFYING_INFO.solr_name).to eq('isbn_qualifying_info_a')
      end

      it 'has a ISSN label' do
        expect(Fields::ISSN.label).to eq('Issn')
      end

      it 'has a ISSN solr name' do
        expect(Fields::ISSN.solr_name).to eq('issn_a')
      end

      it 'has a ISSN_LINKING label' do
        expect(Fields::ISSN_LINKING.label).to eq('Issn Linking')
      end

      it 'has a ISSN_LINKING solr name' do
        expect(Fields::ISSN_LINKING.solr_name).to eq('issn_linking_a')
      end

      it 'has a ISSN_LINKING_ISBN label' do
        expect(Fields::ISSN_LINKING_ISBN.label).to eq('Issn Linking Isbn')
      end

      it 'has a ISSN_LINKING_ISBN solr name' do
        expect(Fields::ISSN_LINKING_ISBN.solr_name).to eq('issn_linking_isbn')
      end

      it 'has a ISSN_PRIMARY label' do
        expect(Fields::ISSN_PRIMARY.label).to eq('Issn Primary')
      end

      it 'has a ISSN_PRIMARY solr name' do
        expect(Fields::ISSN_PRIMARY.solr_name).to eq('issn_primary_a')
      end

      it 'has a ISSN_PRIMARY_ISBN label' do
        expect(Fields::ISSN_PRIMARY_ISBN.label).to eq('Issn Primary Isbn')
      end

      it 'has a ISSN_PRIMARY_ISBN solr name' do
        expect(Fields::ISSN_PRIMARY_ISBN.solr_name).to eq('issn_primary_isbn')
      end

      it 'has a ISSN_SERIES label' do
        expect(Fields::ISSN_SERIES.label).to eq('Issn Series')
      end

      it 'has a ISSN_SERIES solr name' do
        expect(Fields::ISSN_SERIES.solr_name).to eq('issn_series_a')
      end

      it 'has a ISSN_SERIES_ISBN label' do
        expect(Fields::ISSN_SERIES_ISBN.label).to eq('Issn Series Isbn')
      end

      it 'has a ISSN_SERIES_ISBN solr name' do
        expect(Fields::ISSN_SERIES_ISBN.solr_name).to eq('issn_series_isbn')
      end

      it 'has a ITEMS_BARCODE label' do
        expect(Fields::ITEMS_BARCODE.label).to eq('Items Barcode')
      end

      it 'has a ITEMS_BARCODE solr name' do
        expect(Fields::ITEMS_BARCODE.solr_name).to eq('items_barcode_a')
      end

      it 'has a ITEMS_CALL_NUMBER label' do
        expect(Fields::ITEMS_CALL_NUMBER.label).to eq('Items Call Number')
      end

      it 'has a ITEMS_CALL_NUMBER solr name' do
        expect(Fields::ITEMS_CALL_NUMBER.solr_name).to eq('items_call_number_a')
      end

      it 'has a ITEMS_CALL_NUMBER_LCCN label' do
        expect(Fields::ITEMS_CALL_NUMBER_LCCN.label).to eq('Items Call Number Lccn')
      end

      it 'has a ITEMS_CALL_NUMBER_LCCN solr name' do
        expect(Fields::ITEMS_CALL_NUMBER_LCCN.solr_name).to eq('items_call_number_lccn')
      end

      it 'has a ITEMS_CALL_NUMBER_SCHEME label' do
        expect(Fields::ITEMS_CALL_NUMBER_SCHEME.label).to eq('Items Call Number Scheme')
      end

      it 'has a ITEMS_CALL_NUMBER_SCHEME solr name' do
        expect(Fields::ITEMS_CALL_NUMBER_SCHEME.solr_name).to eq('items_call_number_scheme_a')
      end

      it 'has a ITEMS_CHECKOUTS label' do
        expect(Fields::ITEMS_CHECKOUTS.label).to eq('Items Checkouts')
      end

      it 'has a ITEMS_CHECKOUTS solr name' do
        expect(Fields::ITEMS_CHECKOUTS.solr_name).to eq('items_checkouts_a')
      end

      it 'has a ITEMS_COPY_NUMBER label' do
        expect(Fields::ITEMS_COPY_NUMBER.label).to eq('Items Copy Number')
      end

      it 'has a ITEMS_COPY_NUMBER solr name' do
        expect(Fields::ITEMS_COPY_NUMBER.solr_name).to eq('items_copy_number_a')
      end

      it 'has a ITEMS_DUE_DATE label' do
        expect(Fields::ITEMS_DUE_DATE.label).to eq('Items Due Date')
      end

      it 'has a ITEMS_DUE_DATE solr name' do
        expect(Fields::ITEMS_DUE_DATE.solr_name).to eq('items_due_date_a')
      end

      it 'has a ITEMS_ILS_ID label' do
        expect(Fields::ITEMS_ILS_ID.label).to eq('Items Ils')
      end

      it 'has a ITEMS_ILS_ID solr name' do
        expect(Fields::ITEMS_ILS_ID.solr_name).to eq('items_ils_id_a')
      end

      it 'has a ITEMS_ILS_NUMBER label' do
        expect(Fields::ITEMS_ILS_NUMBER.label).to eq('Items Ils Number')
      end

      it 'has a ITEMS_ILS_NUMBER solr name' do
        expect(Fields::ITEMS_ILS_NUMBER.solr_name).to eq('items_ils_number_a')
      end

      it 'has a ITEMS_LCC_TOP label' do
        expect(Fields::ITEMS_LCC_TOP.label).to eq('Items Lcc Top')
      end

      it 'has a ITEMS_LCC_TOP solr name' do
        expect(Fields::ITEMS_LCC_TOP.solr_name).to eq('items_lcc_top_a')
      end

      it 'has a ITEMS_LOCATION label' do
        expect(Fields::ITEMS_LOCATION.label).to eq('Items Location')
      end

      it 'has a ITEMS_LOCATION solr name' do
        expect(Fields::ITEMS_LOCATION.solr_name).to eq('items_location_a')
      end

      it 'has a ITEMS_NOTE label' do
        expect(Fields::ITEMS_NOTE.label).to eq('Items Note')
      end

      it 'has a ITEMS_NOTE solr name' do
        expect(Fields::ITEMS_NOTE.solr_name).to eq('items_note_a')
      end

      it 'has a ITEMS_STATUS label' do
        expect(Fields::ITEMS_STATUS.label).to eq('Items Status')
      end

      it 'has a ITEMS_STATUS solr name' do
        expect(Fields::ITEMS_STATUS.solr_name).to eq('items_status_a')
      end

      it 'has a ITEMS_TYPE label' do
        expect(Fields::ITEMS_TYPE.label).to eq('Items Type')
      end

      it 'has a ITEMS_TYPE solr name' do
        expect(Fields::ITEMS_TYPE.solr_name).to eq('items_type_a')
      end

      it 'has a ITEMS_VOLUME label' do
        expect(Fields::ITEMS_VOLUME.label).to eq('Items Volume')
      end

      it 'has a ITEMS_VOLUME solr name' do
        expect(Fields::ITEMS_VOLUME.solr_name).to eq('items_volume_a')
      end

      it 'has a LANG_CODE label' do
        expect(Fields::LANG_CODE.label).to eq('Lang Code')
      end

      it 'has a LANG_CODE solr name' do
        expect(Fields::LANG_CODE.solr_name).to eq('lang_code_a')
      end

      it 'has a LANGUAGE label' do
        expect(Fields::LANGUAGE.label).to eq('Language')
      end

      it 'has a LANGUAGE solr name' do
        expect(Fields::LANGUAGE.solr_name).to eq('language_a')
      end

      it 'has a LINKING_ADDED_ENTRY label' do
        expect(Fields::LINKING_ADDED_ENTRY.label).to eq('Linking Added Entry')
      end

      it 'has a LINKING_ADDED_ENTRY solr name' do
        expect(Fields::LINKING_ADDED_ENTRY.solr_name).to eq('linking_added_entry_a')
      end

      it 'has a LINKING_HAS_SUPPLEMENT label' do
        expect(Fields::LINKING_HAS_SUPPLEMENT.label).to eq('Linking Has Supplement')
      end

      it 'has a LINKING_HAS_SUPPLEMENT solr name' do
        expect(Fields::LINKING_HAS_SUPPLEMENT.solr_name).to eq('linking_has_supplement_a')
      end

      it 'has a LINKING_HAS_SUPPLEMENT_ISN label' do
        expect(Fields::LINKING_HAS_SUPPLEMENT_ISN.label).to eq('Linking Has Supplement Isn')
      end

      it 'has a LINKING_HAS_SUPPLEMENT_ISN solr name' do
        expect(Fields::LINKING_HAS_SUPPLEMENT_ISN.solr_name).to eq('linking_has_supplement_isn_a')
      end

      it 'has a LINKING_HOST_ITEM label' do
        expect(Fields::LINKING_HOST_ITEM.label).to eq('Linking Host Item')
      end

      it 'has a LINKING_HOST_ITEM solr name' do
        expect(Fields::LINKING_HOST_ITEM.solr_name).to eq('linking_host_item_a')
      end

      it 'has a LINKING_HOST_ITEM_TITLE label' do
        expect(Fields::LINKING_HOST_ITEM_TITLE.label).to eq('Linking Host Item Title')
      end

      it 'has a LINKING_HOST_ITEM_TITLE solr name' do
        expect(Fields::LINKING_HOST_ITEM_TITLE.solr_name).to eq('linking_host_item_title_a')
      end

      it 'has a LINKING_ISN label' do
        expect(Fields::LINKING_ISN.label).to eq('Linking Isn')
      end

      it 'has a LINKING_ISN solr name' do
        expect(Fields::LINKING_ISN.solr_name).to eq('linking_isn_a')
      end

      it 'has a LINKING_MAIN_SERIES label' do
        expect(Fields::LINKING_MAIN_SERIES.label).to eq('Linking Main Series')
      end

      it 'has a LINKING_MAIN_SERIES solr name' do
        expect(Fields::LINKING_MAIN_SERIES.solr_name).to eq('linking_main_series_a')
      end

      it 'has a LINKING_SUPPLEMENT_TO label' do
        expect(Fields::LINKING_SUPPLEMENT_TO.label).to eq('Linking Supplement To')
      end

      it 'has a LINKING_SUPPLEMENT_TO solr name' do
        expect(Fields::LINKING_SUPPLEMENT_TO.solr_name).to eq('linking_supplement_to_a')
      end

      it 'has a LINKING_SUPPLEMENT_TO_ISN label' do
        expect(Fields::LINKING_SUPPLEMENT_TO_ISN.label).to eq('Linking Supplement To Isn')
      end

      it 'has a LINKING_SUPPLEMENT_TO_ISN solr name' do
        expect(Fields::LINKING_SUPPLEMENT_TO_ISN.solr_name).to eq('linking_supplement_to_isn_a')
      end

      it 'has a LINKING_TRANSLATED_AS_TITLE label' do
        expect(Fields::LINKING_TRANSLATED_AS_TITLE.label).to eq('Linking Translated As Title')
      end

      it 'has a LINKING_TRANSLATED_AS_TITLE solr name' do
        expect(Fields::LINKING_TRANSLATED_AS_TITLE.solr_name).to eq('linking_translated_as_title_a')
      end

      it 'has a LINKING_TRANSLATION_OF label' do
        expect(Fields::LINKING_TRANSLATION_OF.label).to eq('Linking Translation Of')
      end

      it 'has a LINKING_TRANSLATION_OF solr name' do
        expect(Fields::LINKING_TRANSLATION_OF.solr_name).to eq('linking_translation_of_a')
      end

      it 'has a LINKING_TRANSLATION_OF_TITLE label' do
        expect(Fields::LINKING_TRANSLATION_OF_TITLE.label).to eq('Linking Translation Of Title')
      end

      it 'has a LINKING_TRANSLATION_OF_TITLE solr name' do
        expect(Fields::LINKING_TRANSLATION_OF_TITLE.solr_name).to eq('linking_translation_of_title_a')
      end

      it 'has a LINKINT_SUPPLEMENT_TO label' do
        expect(Fields::LINKINT_SUPPLEMENT_TO.label).to eq('Linkint Supplement To')
      end

      it 'has a LINKINT_SUPPLEMENT_TO solr name' do
        expect(Fields::LINKINT_SUPPLEMENT_TO.solr_name).to eq('linkint_supplement_to_a')
      end

      it 'has a LOCAL_ID label' do
        expect(Fields::LOCAL_ID.label).to eq('Local')
      end

      it 'has a LOCAL_ID solr name' do
        expect(Fields::LOCAL_ID.solr_name).to eq('local_id')
      end

      it 'has a MANUFACTURER label' do
        expect(Fields::MANUFACTURER.label).to eq('Manufacturer')
      end

      it 'has a MANUFACTURER solr name' do
        expect(Fields::MANUFACTURER.solr_name).to eq('manufacturer_a')
      end

      it 'has a MANUFACTURER_STATEMENT label' do
        expect(Fields::MANUFACTURER_STATEMENT.label).to eq('Manufacturer Statement')
      end

      it 'has a MANUFACTURER_STATEMENT solr name' do
        expect(Fields::MANUFACTURER_STATEMENT.solr_name).to eq('manufacturer_statement_a')
      end

      it 'has a NOTES_ADDITIONAL label' do
        expect(Fields::NOTES_ADDITIONAL.label).to eq('Notes Additional')
      end

      it 'has a NOTES_ADDITIONAL solr name' do
        expect(Fields::NOTES_ADDITIONAL.solr_name).to eq('notes_additional_a')
      end

      it 'has a NOTES_ADDITIONAL_VERNACULAR_LANG label' do
        expect(Fields::NOTES_ADDITIONAL_VERNACULAR_LANG.label).to eq('Notes Additional Vernacular Lang')
      end

      it 'has a NOTES_ADDITIONAL_VERNACULAR_LANG solr name' do
        expect(Fields::NOTES_ADDITIONAL_VERNACULAR_LANG.solr_name).to eq('notes_additional_vernacular_lang_a')
      end

      it 'has a NOTES_INDEXED label' do
        expect(Fields::NOTES_INDEXED.label).to eq('Notes Indexed')
      end

      it 'has a NOTES_INDEXED solr name' do
        expect(Fields::NOTES_INDEXED.solr_name).to eq('notes_indexed_a')
      end

      it 'has a NOTES_INDEXED_CJK label' do
        expect(Fields::NOTES_INDEXED_CJK.label).to eq('Notes Indexed Cjk')
      end

      it 'has a NOTES_INDEXED_CJK solr name' do
        expect(Fields::NOTES_INDEXED_CJK.solr_name).to eq('notes_indexed_cjk_v')
      end

      it 'has a NOTES_INDEXED_RUS label' do
        expect(Fields::NOTES_INDEXED_RUS.label).to eq('Notes Indexed Rus')
      end

      it 'has a NOTES_INDEXED_RUS solr name' do
        expect(Fields::NOTES_INDEXED_RUS.solr_name).to eq('notes_indexed_rus_v')
      end

      it 'has a NOTES_INDEXED_VERN label' do
        expect(Fields::NOTES_INDEXED_VERN.label).to eq('Notes Indexed Vern')
      end

      it 'has a NOTES_INDEXED_VERN solr name' do
        expect(Fields::NOTES_INDEXED_VERN.solr_name).to eq('notes_indexed_vern')
      end

      it 'has a NOTES_INDEXED_VERNACULAR_LANG label' do
        expect(Fields::NOTES_INDEXED_VERNACULAR_LANG.label).to eq('Notes Indexed Vernacular Lang')
      end

      it 'has a NOTES_INDEXED_VERNACULAR_LANG solr name' do
        expect(Fields::NOTES_INDEXED_VERNACULAR_LANG.solr_name).to eq('notes_indexed_vernacular_lang_a')
      end

      it 'has a OCLC_NUMBER label' do
        expect(Fields::OCLC_NUMBER.label).to eq('Oclc Number')
      end

      it 'has a OCLC_NUMBER solr name' do
        expect(Fields::OCLC_NUMBER.solr_name).to eq('oclc_number')
      end

      it 'has a OCLC_NUMBER_OLD label' do
        expect(Fields::OCLC_NUMBER_OLD.label).to eq('Oclc Number Old')
      end

      it 'has a OCLC_NUMBER_OLD solr name' do
        expect(Fields::OCLC_NUMBER_OLD.solr_name).to eq('oclc_number_old_a')
      end

      it 'has a ORGANIZATION_ARRANGEMENT label' do
        expect(Fields::ORGANIZATION_ARRANGEMENT.label).to eq('Organization Arrangement')
      end

      it 'has a ORGANIZATION_ARRANGEMENT solr name' do
        expect(Fields::ORGANIZATION_ARRANGEMENT.solr_name).to eq('organization_arrangement_a')
      end

      it 'has a OWNER label' do
        expect(Fields::OWNER.label).to eq('Owner')
      end

      it 'has a OWNER solr name' do
        expect(Fields::OWNER.solr_name).to eq('owner_a')
      end

      it 'has a PRODUCER label' do
        expect(Fields::PRODUCER.label).to eq('Producer')
      end

      it 'has a PRODUCER solr name' do
        expect(Fields::PRODUCER.solr_name).to eq('producer_a')
      end

      it 'has a PRODUCTION_STATEMENT label' do
        expect(Fields::PRODUCTION_STATEMENT.label).to eq('Production Statement')
      end

      it 'has a PRODUCTION_STATEMENT solr name' do
        expect(Fields::PRODUCTION_STATEMENT.solr_name).to eq('production_statement_a')
      end

      it 'has a PUBLISHER label' do
        expect(Fields::PUBLISHER.label).to eq('Publisher')
      end

      it 'has a PUBLISHER solr name' do
        expect(Fields::PUBLISHER.solr_name).to eq('publisher_a')
      end

      it 'has a PUBLISHER_ETC label' do
        expect(Fields::PUBLISHER_ETC.label).to eq('Publisher Etc')
      end

      it 'has a PUBLISHER_ETC solr name' do
        expect(Fields::PUBLISHER_ETC.solr_name).to eq('publisher_etc_a')
      end

      it 'has a PUBLISHER_ETC_TYPE label' do
        expect(Fields::PUBLISHER_ETC_TYPE.label).to eq('Publisher Etc Type')
      end

      it 'has a PUBLISHER_ETC_TYPE solr name' do
        expect(Fields::PUBLISHER_ETC_TYPE.solr_name).to eq('publisher_etc_type_a')
      end

      it 'has a PUBLISHER_IMPRINT label' do
        expect(Fields::PUBLISHER_IMPRINT.label).to eq('Publisher Imprint')
      end

      it 'has a PUBLISHER_IMPRINT solr name' do
        expect(Fields::PUBLISHER_IMPRINT.solr_name).to eq('publisher_imprint_a')
      end

      it 'has a PUBLISHER_MARC_SOURCE label' do
        expect(Fields::PUBLISHER_MARC_SOURCE.label).to eq('Publisher Marc Source')
      end

      it 'has a PUBLISHER_MARC_SOURCE solr name' do
        expect(Fields::PUBLISHER_MARC_SOURCE.solr_name).to eq('publisher_marc_source_a')
      end

      it 'has a PUBLISHER_NUMBER label' do
        expect(Fields::PUBLISHER_NUMBER.label).to eq('Publisher Number')
      end

      it 'has a PUBLISHER_NUMBER solr name' do
        expect(Fields::PUBLISHER_NUMBER.solr_name).to eq('publisher_number_a')
      end

      it 'has a PUBLISHER_VERNACULAR_LANG label' do
        expect(Fields::PUBLISHER_VERNACULAR_LANG.label).to eq('Publisher Vernacular Lang')
      end

      it 'has a PUBLISHER_VERNACULAR_LANG solr name' do
        expect(Fields::PUBLISHER_VERNACULAR_LANG.solr_name).to eq('publisher_vernacular_lang_a')
      end

      it 'has a SERIES label' do
        expect(Fields::SERIES.label).to eq('Series')
      end

      it 'has a SERIES solr name' do
        expect(Fields::SERIES.solr_name).to eq('series_a')
      end

      it 'has a SERIES_DIGITAL_FILE label' do
        expect(Fields::SERIES_DIGITAL_FILE.label).to eq('Series Digital File')
      end

      it 'has a SERIES_DIGITAL_FILE solr name' do
        expect(Fields::SERIES_DIGITAL_FILE.solr_name).to eq('series_digital_file_a')
      end

      it 'has a SERIES_GENERAL label' do
        expect(Fields::SERIES_GENERAL.label).to eq('Series General')
      end

      it 'has a SERIES_GENERAL solr name' do
        expect(Fields::SERIES_GENERAL.solr_name).to eq('series_general_a')
      end

      it 'has a SERIES_ORGANIZATION label' do
        expect(Fields::SERIES_ORGANIZATION.label).to eq('Series Organization')
      end

      it 'has a SERIES_ORGANIZATION solr name' do
        expect(Fields::SERIES_ORGANIZATION.solr_name).to eq('series_organization_a')
      end

      it 'has a SERIES_PROJECTION label' do
        expect(Fields::SERIES_PROJECTION.label).to eq('Series Projection')
      end

      it 'has a SERIES_PROJECTION solr name' do
        expect(Fields::SERIES_PROJECTION.solr_name).to eq('series_projection_a')
      end

      it 'has a SERIES_SOUND label' do
        expect(Fields::SERIES_SOUND.label).to eq('Series Sound')
      end

      it 'has a SERIES_SOUND solr name' do
        expect(Fields::SERIES_SOUND.solr_name).to eq('series_sound_a')
      end

      it 'has a SERIES_STATEMENT label' do
        expect(Fields::SERIES_STATEMENT.label).to eq('Series Statement')
      end

      it 'has a SERIES_STATEMENT solr name' do
        expect(Fields::SERIES_STATEMENT.solr_name).to eq('series_statement_a')
      end

      it 'has a SERIES_STATEMENT_VERNACULAR_LANG label' do
        expect(Fields::SERIES_STATEMENT_VERNACULAR_LANG.label).to eq('Series Statement Vernacular Lang')
      end

      it 'has a SERIES_STATEMENT_VERNACULAR_LANG solr name' do
        expect(Fields::SERIES_STATEMENT_VERNACULAR_LANG.solr_name).to eq('series_statement_vernacular_lang_a')
      end

      it 'has a SERIES_TITLE_INDEX label' do
        expect(Fields::SERIES_TITLE_INDEX.label).to eq('Series Title Index')
      end

      it 'has a SERIES_TITLE_INDEX solr name' do
        expect(Fields::SERIES_TITLE_INDEX.solr_name).to eq('series_title_index_a')
      end

      it 'has a SERIES_VIDEO label' do
        expect(Fields::SERIES_VIDEO.label).to eq('Series Video')
      end

      it 'has a SERIES_VIDEO solr name' do
        expect(Fields::SERIES_VIDEO.solr_name).to eq('series_video_a')
      end

      it 'has a SERIES_VOLUMES label' do
        expect(Fields::SERIES_VOLUMES.label).to eq('Series Volumes')
      end

      it 'has a SERIES_VOLUMES solr name' do
        expect(Fields::SERIES_VOLUMES.solr_name).to eq('series_volumes_a')
      end

      it 'has a SOURCE label' do
        expect(Fields::SOURCE.label).to eq('Source')
      end

      it 'has a SOURCE solr name' do
        expect(Fields::SOURCE.solr_name).to eq('source_a')
      end

      it 'has a STATEMENT_OF_RESPONSIBILITY label' do
        expect(Fields::STATEMENT_OF_RESPONSIBILITY.label).to eq('Statement Of Responsibility')
      end

      it 'has a STATEMENT_OF_RESPONSIBILITY solr name' do
        expect(Fields::STATEMENT_OF_RESPONSIBILITY.solr_name).to eq('statement_of_responsibility_a')
      end

      it 'has a STATEMENT_OF_RESPONSIBILITY_CJK label' do
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_CJK.label).to eq('Statement Of Responsibility Cjk')
      end

      it 'has a STATEMENT_OF_RESPONSIBILITY_CJK solr name' do
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_CJK.solr_name).to eq('statement_of_responsibility_cjk_v')
      end

      it 'has a STATEMENT_OF_RESPONSIBILITY_RUS label' do
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_RUS.label).to eq('Statement Of Responsibility Rus')
      end

      it 'has a STATEMENT_OF_RESPONSIBILITY_RUS solr name' do
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_RUS.solr_name).to eq('statement_of_responsibility_rus_v')
      end

      it 'has a STATEMENT_OF_RESPONSIBILITY_VERN label' do
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_VERN.label).to eq('Statement Of Responsibility Vern')
      end

      it 'has a STATEMENT_OF_RESPONSIBILITY_VERN solr name' do
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_VERN.solr_name).to eq('statement_of_responsibility_vern')
      end

      it 'has a STATEMENT_OF_RESPONSIBILITY_VERNACULAR_LANG label' do
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_VERNACULAR_LANG.label).to(
          eq('Statement Of Responsibility Vernacular Lang')
        )
      end

      it 'has a STATEMENT_OF_RESPONSIBILITY_VERNACULAR_LANG solr name' do
        expect(Fields::STATEMENT_OF_RESPONSIBILITY_VERNACULAR_LANG.solr_name).to(
          eq('statement_of_responsibility_vernacular_lang_a')
        )
      end

      it 'has a SUBJECTS label' do
        expect(Fields::SUBJECTS.label).to eq('Subjects')
      end

      it 'has a SUBJECTS solr name' do
        expect(Fields::SUBJECTS.solr_name).to eq('subjects_a')
      end

      it 'has a SYNDETICS_ID label' do
        expect(Fields::SYNDETICS_ID.label).to eq('Syndetics')
      end

      it 'has a SYNDETICS_ID solr name' do
        expect(Fields::SYNDETICS_ID.solr_name).to eq('syndetics_id_a')
      end

      it 'has a SYNDETICS_ISBN label' do
        expect(Fields::SYNDETICS_ISBN.label).to eq('Syndetics Isbn')
      end

      it 'has a SYNDETICS_ISBN solr name' do
        expect(Fields::SYNDETICS_ISBN.solr_name).to eq('syndetics_isbn_a')
      end

      it 'has a TITLE_ABBREVIATION label' do
        expect(Fields::TITLE_ABBREVIATION.label).to eq('Title Abbreviation')
      end

      it 'has a TITLE_ABBREVIATION solr name' do
        expect(Fields::TITLE_ABBREVIATION.solr_name).to eq('title_abbreviation_a')
      end

      it 'has a TITLE_ABBRV label' do
        expect(Fields::TITLE_ABBRV.label).to eq('Title Abbrv')
      end

      it 'has a TITLE_ABBRV solr name' do
        expect(Fields::TITLE_ABBRV.solr_name).to eq('title_abbrv_a')
      end

      it 'has a TITLE_ALT label' do
        expect(Fields::TITLE_ALT.label).to eq('Title Alt')
      end

      it 'has a TITLE_ALT solr name' do
        expect(Fields::TITLE_ALT.solr_name).to eq('title_alt_a')
      end

      it 'has a TITLE_ALT_VERNACULAR_LANG label' do
        expect(Fields::TITLE_ALT_VERNACULAR_LANG.label).to eq('Title Alt Vernacular Lang')
      end

      it 'has a TITLE_ALT_VERNACULAR_LANG solr name' do
        expect(Fields::TITLE_ALT_VERNACULAR_LANG.solr_name).to eq('title_alt_vernacular_lang_a')
      end

      it 'has a TITLE_ALTERNATE label' do
        expect(Fields::TITLE_ALTERNATE.label).to eq('Title Alternate')
      end

      it 'has a TITLE_ALTERNATE solr name' do
        expect(Fields::TITLE_ALTERNATE.solr_name).to eq('title_alternate_a')
      end

      it 'has a TITLE_ANALYTICAL label' do
        expect(Fields::TITLE_ANALYTICAL.label).to eq('Title Analytical')
      end

      it 'has a TITLE_ANALYTICAL solr name' do
        expect(Fields::TITLE_ANALYTICAL.solr_name).to eq('title_analytical_a')
      end

      it 'has a TITLE_EARLIER label' do
        expect(Fields::TITLE_EARLIER.label).to eq('Title Earlier')
      end

      it 'has a TITLE_EARLIER solr name' do
        expect(Fields::TITLE_EARLIER.solr_name).to eq('title_earlier_a')
      end

      it 'has a TITLE_JOURNAL label' do
        expect(Fields::TITLE_JOURNAL.label).to eq('Title Journal')
      end

      it 'has a TITLE_JOURNAL solr name' do
        expect(Fields::TITLE_JOURNAL.solr_name).to eq('title_journal_a')
      end

      it 'has a TITLE_JOURNAL_CJK label' do
        expect(Fields::TITLE_JOURNAL_CJK.label).to eq('Title Journal Cjk')
      end

      it 'has a TITLE_JOURNAL_CJK solr name' do
        expect(Fields::TITLE_JOURNAL_CJK.solr_name).to eq('title_journal_cjk_v')
      end

      it 'has a TITLE_JOURNAL_VERN label' do
        expect(Fields::TITLE_JOURNAL_VERN.label).to eq('Title Journal Vern')
      end

      it 'has a TITLE_JOURNAL_VERN solr name' do
        expect(Fields::TITLE_JOURNAL_VERN.solr_name).to eq('title_journal_vern')
      end

      it 'has a TITLE_JOURNAL_VERNACULAR_LANG label' do
        expect(Fields::TITLE_JOURNAL_VERNACULAR_LANG.label).to eq('Title Journal Vernacular Lang')
      end

      it 'has a TITLE_JOURNAL_VERNACULAR_LANG solr name' do
        expect(Fields::TITLE_JOURNAL_VERNACULAR_LANG.solr_name).to eq('title_journal_vernacular_lang_a')
      end

      it 'has a TITLE_LATER label' do
        expect(Fields::TITLE_LATER.label).to eq('Title Later')
      end

      it 'has a TITLE_LATER solr name' do
        expect(Fields::TITLE_LATER.solr_name).to eq('title_later_a')
      end

      it 'has a TITLE_MAIN label' do
        expect(Fields::TITLE_MAIN.label).to eq('Title')
      end

      it 'has a TITLE_MAIN solr name' do
        expect(Fields::TITLE_MAIN.solr_name).to eq('title_main')
      end

      it 'has a TITLE_MAIN_CJK label' do
        expect(Fields::TITLE_MAIN_CJK.label).to eq('Title Main Cjk')
      end

      it 'has a TITLE_MAIN_CJK solr name' do
        expect(Fields::TITLE_MAIN_CJK.solr_name).to eq('title_main_cjk_v')
      end

      it 'has a TITLE_MAIN_RUS label' do
        expect(Fields::TITLE_MAIN_RUS.label).to eq('Title Main Rus')
      end

      it 'has a TITLE_MAIN_RUS solr name' do
        expect(Fields::TITLE_MAIN_RUS.solr_name).to eq('title_main_rus_v')
      end

      it 'has a TITLE_MAIN_VERN label' do
        expect(Fields::TITLE_MAIN_VERN.label).to eq('Title Main Vern')
      end

      it 'has a TITLE_MAIN_VERN solr name' do
        expect(Fields::TITLE_MAIN_VERN.solr_name).to eq('title_main_vern')
      end

      it 'has a TITLE_MAIN_VERNACULAR_LANG label' do
        expect(Fields::TITLE_MAIN_VERNACULAR_LANG.label).to eq('Title Main Vernacular Lang')
      end

      it 'has a TITLE_MAIN_VERNACULAR_LANG solr name' do
        expect(Fields::TITLE_MAIN_VERNACULAR_LANG.solr_name).to eq('title_main_vernacular_lang_a')
      end

      it 'has a TITLE_TRANSLATION label' do
        expect(Fields::TITLE_TRANSLATION.label).to eq('Title Translation')
      end

      it 'has a TITLE_TRANSLATION solr name' do
        expect(Fields::TITLE_TRANSLATION.solr_name).to eq('title_translation_a')
      end

      it 'has a TITLE_UNIFORM label' do
        expect(Fields::TITLE_UNIFORM.label).to eq('Title Uniform')
      end

      it 'has a TITLE_UNIFORM solr name' do
        expect(Fields::TITLE_UNIFORM.solr_name).to eq('title_uniform_a')
      end

      it 'has a UPC label' do
        expect(Fields::UPC.label).to eq('Upc')
      end

      it 'has a UPC solr name' do
        expect(Fields::UPC.solr_name).to eq('upc_a')
      end

      it 'has a URL_HREF label' do
        expect(Fields::URL_HREF.label).to eq('Link')
      end

      it 'has a URL_HREF solr name' do
        expect(Fields::URL_HREF.solr_name).to eq('url_href_a')
      end

      it 'has a URL_REL label' do
        expect(Fields::URL_REL.label).to eq('Url Rel')
      end

      it 'has a URL_REL solr name' do
        expect(Fields::URL_REL.solr_name).to eq('url_rel_a')
      end

      it 'has a URL_TEXT label' do
        expect(Fields::URL_TEXT.label).to eq('Url Text')
      end

      it 'has a URL_TEXT solr name' do
        expect(Fields::URL_TEXT.solr_name).to eq('url_text_a')
      end

      it 'has a VOLUME_DATE_RANGE label' do
        expect(Fields::VOLUME_DATE_RANGE.label).to eq('Volume Date Range')
      end

      it 'has a VOLUME_DATE_RANGE solr name' do
        expect(Fields::VOLUME_DATE_RANGE.solr_name).to eq('volume_date_range_a')
      end
    end

    describe 'sort field constants' do
      it 'has an AUTHORS_SORT label' do
        expect(Fields::AUTHORS_SORT.label).to eq('Authors Sort')
      end

      it 'has an AUTHORS_SORT solr name' do
        expect(Fields::AUTHORS_SORT.solr_name).to eq('authors_sort_a')
      end

      it 'has a PUBLICATION_DATE_SORT label' do
        expect(Fields::PUBLICATION_DATE_SORT.label).to eq('Publication Year')
      end

      it 'has a PUBLICATION_DATE_SORT solr name' do
        expect(Fields::PUBLICATION_DATE_SORT.solr_name).to eq('publication_year_isort_stored_single')
      end

      it 'has a TITLE_SORT label' do
        expect(Fields::TITLE_SORT.label).to eq('Title Sort Ssort Single')
      end

      it 'has a TITLE_SORT solr name' do
        expect(Fields::TITLE_SORT.solr_name).to eq('title_sort_ssort_single')
      end
    end
  end
end
