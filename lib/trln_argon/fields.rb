module TrlnArgon
  module Fields

      ROLLUP_ID                   = TrlnArgon::Field.new :rollup_id

      CALL_NUMBER_FACET           = TrlnArgon::Field.new :items_lcc_top_f
      FORMAT_FACET                = TrlnArgon::Field.new :format_f
      INSTITUTION_FACET           = TrlnArgon::Field.new :institution_f
      LANGUAGE_FACET              = TrlnArgon::Field.new :language_f
      PUBLICATION_YEAR_FACET      = TrlnArgon::Field.new :publication_year
      SUBJECTS_FACET              = TrlnArgon::Field.new :subjects_f

      AUTHORS_MAIN_DISPLAY        = TrlnArgon::Field.new :authors_main_a
      AUTHORS_MAIN_VERN_DISPLAY   = TrlnArgon::Field.new :authors_main_vern
      FORMAT_DISPLAY              = TrlnArgon::Field.new :format_a
      INSTITUTION_DISPLAY         = TrlnArgon::Field.new :institution_a
      ISBN_PRIMARY_NUMBER_DISPLAY = TrlnArgon::Field.new :isbn_primary_number_a
      LANGUAGE_DISPLAY            = TrlnArgon::Field.new :language_a
      PUBLISHER_ETC_NAME_DISPLAY  = TrlnArgon::Field.new :publisher_etc_name_a
      TITLE_MAIN_DISPLAY          = TrlnArgon::Field.new :title_main
      TITLE_MAIN_VERN_DISPLAY     = TrlnArgon::Field.new :title_main_vern
      URL_HREF_DISPLAY            = TrlnArgon::Field.new :url_href_a

      # AUTHOR_SORT                 = TrlnArgon::Field.new :author_sort
      PUBLICATION_DATE_SORT       = TrlnArgon::Field.new :publication_year_isort_stored_single
      TITLE_SORT                  = TrlnArgon::Field.new :title_sort_ssort_single


  end
end