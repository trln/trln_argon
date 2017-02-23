module TrlnArgon
  module Fields

      INSTITUTION                 = TrlnArgon::Field.new :institution_a
      ROLLUP_ID                   = TrlnArgon::Field.new :rollup_id

      CALL_NUMBER_TAG_FACET       = TrlnArgon::Field.new :items_call_number_tag_f
      FORMAT_FACET                = TrlnArgon::Field.new :format_f
      LANGUAGE_FACET              = TrlnArgon::Field.new :language_f
      PUBLICATION_YEAR_FACET      = TrlnArgon::Field.new :publication_year
      SUBJECTS_FACET              = TrlnArgon::Field.new :subjects_pp

      AUTHORS_MAIN_DISPLAY        = TrlnArgon::Field.new :authors_main_a
      FORMAT_DISPLAY              = TrlnArgon::Field.new :format_a
      ISBN_PRIMARY_NUMBER_DISPLAY = TrlnArgon::Field.new :isbn_primary_number_a
      LANGUAGE_DISPLAY            = TrlnArgon::Field.new :language_a
      PUBLISHER_ETC_NAME_DISPLAY  = TrlnArgon::Field.new :publisher_etc_name_a
      TITLE_MAIN_DISPLAY          = TrlnArgon::Field.new :title_main
      URL_HREF_DISPLAY            = TrlnArgon::Field.new :url_href_a

      PUBLICATION_YEAR_SORT       = TrlnArgon::Field.new :publication_year_isort_stored_single
      TITLE_SORT                  = TrlnArgon::Field.new :title_sort_ssort_single

  end
end