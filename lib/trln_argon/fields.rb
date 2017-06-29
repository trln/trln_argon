module TrlnArgon
  module Fields
    # Rollup ID constant
    ROLLUP_ID              = TrlnArgon::Field.new :rollup_id

    # Display field constants
    AUTHORS_MAIN           = TrlnArgon::Field.new :authors_main_a
    AUTHORS_MAIN_VERN      = TrlnArgon::Field.new :authors_main_vern
    FORMAT                 = TrlnArgon::Field.new :format_a
    INSTITUTION            = TrlnArgon::Field.new :institution_a
    ISBN_NUMBER            = TrlnArgon::Field.new :isbn_number_a
    LANGUAGE               = TrlnArgon::Field.new :language_a
    PUBLISHER_ETC          = TrlnArgon::Field.new :publisher_etc_a
    SUBJECTS               = TrlnArgon::Field.new :subjects_a
    TITLE_MAIN             = TrlnArgon::Field.new :title_main
    TITLE_MAIN_VERN        = TrlnArgon::Field.new :title_main_vern
    URL_HREF               = TrlnArgon::Field.new :url_href_a

    # Facet field constants
    CALL_NUMBER_FACET      = TrlnArgon::Field.new :items_lcc_top_f
    FORMAT_FACET           = TrlnArgon::Field.new :format_f
    INSTITUTION_FACET      = TrlnArgon::Field.new :institution_f
    LANGUAGE_FACET         = TrlnArgon::Field.new :language_f
    SUBJECTS_FACET         = TrlnArgon::Field.new :subjects_f

    # Sort field constants
    PUBLICATION_DATE_SORT  =
      TrlnArgon::Field.new :publication_year_isort_stored_single
    TITLE_SORT             = TrlnArgon::Field.new :title_sort_ssort_single
  end
end
