module TrlnArgon
  module Fields

    ROLLUP_ID              = TrlnArgon::Field.new :rollup_id

    AUTHORS_MAIN           = TrlnArgon::Field.new :authors_main_a
    AUTHORS_MAIN_VERN      = TrlnArgon::Field.new :authors_main_vern
    FORMAT                 = TrlnArgon::Field.new :format_a
    INSTITUTION            = TrlnArgon::Field.new :institution_a
    ISBN_NUMBER            = TrlnArgon::Field.new :isbn_number_a
    LANGUAGE               = TrlnArgon::Field.new :language_a
    PUBLISHER_ETC_NAME     = TrlnArgon::Field.new :publisher_etc_name_a
    TITLE_MAIN             = TrlnArgon::Field.new :title_main
    TITLE_MAIN_VERN        = TrlnArgon::Field.new :title_main_vern
    URL_HREF               = TrlnArgon::Field.new :url_href_a

    CALL_NUMBER_FACET      = TrlnArgon::Field.new :items_lcc_top_f
    FORMAT_FACET           = TrlnArgon::Field.new :format_f
    INSTITUTION_FACET      = TrlnArgon::Field.new :institution_f
    LANGUAGE_FACET         = TrlnArgon::Field.new :language_f
    SUBJECTS_FACET         = TrlnArgon::Field.new :subjects_f

    PUBLICATION_DATE_SORT  = TrlnArgon::Field.new :publication_year_isort_stored_single
    TITLE_SORT             = TrlnArgon::Field.new :title_sort_ssort_single

  end
end
