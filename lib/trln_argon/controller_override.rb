require 'trln_argon/controller_override/local_filter'
require 'trln_argon/controller_override/open_search'
require 'trln_argon/controller_override/paging_limit'
require 'trln_argon/controller_override/solr_caching'

module TrlnArgon
  # Sets the default Blacklight configuration and
  # CatalogController behaviors for TRLN Argon based
  # applications. Override in the local application in
  # app/controllers/catalog_controller.rb
  module ControllerOverride
    extend ActiveSupport::Concern

    included do
      send(:include, LocalFilter)
      send(:include, OpenSearch)
      send(:include, PagingLimit)
      send(:include, SolrCaching)
      send(:include, BlacklightAdvancedSearch::Controller)

      before_action :limit_results_paging, only: :index
      before_action :limit_facet_paging, only: :facet

      helper_method :query_has_constraints?




      # TRLN Argon CatalogController configurations
      configure_blacklight do |config|
        config.search_builder_class = DefaultLocalSearchBuilder
        config.default_per_page = 20

        # Use Solr search requestHandler for search requests
        config.http_method = :get
        config.solr_path = :select

        # Use Solr document requestHandler for document requests
        config.document_solr_path = :document
        config.document_unique_id_param = :id
        config.document_solr_request_handler = nil

        # Configuration for autocomplete suggester
        config.autocomplete_enabled = true
        config.autocomplete_solr_component = 'suggest'
        config.autocomplete_path = 'suggest'
        config.autocomplete_path_title = 'suggest_title'
        config.autocomplete_path_author = 'suggest_author'
        config.autocomplete_path_subject = 'suggest_subject'

        config.add_results_collection_tool(:sort_widget)
        config.add_results_collection_tool(:per_page_widget)



        config.show.heading_partials = %i[show_header show_thumbnail show_sub_header]
        config.show.partials = %i[show_items
                                  show_authors
                                  show_summary
                                  show_included_works
                                  show_subjects
                                  show
                                  show_related_works]

        # Disable these tools in the UI for now.
        # See add_show_tools_partial methods above for
        # tools configuration

        # Set partials to render
        config.index.partials = %i[index_header thumbnail index index_items]

        config.show.document_actions.delete(:bookmark)

        config.add_show_tools_partial(:email,
                                      icon: 'fa fa-envelope',
                                      callback: :email_action,
                                      path: :email_path,
                                      validator: :validate_email_params)
        config.add_show_tools_partial(:sms,
                                      icon: 'fa fa-commenting',
                                      if: :render_sms_action?,
                                      callback: :sms_action,
                                      path: :sms_path,
                                      validator: :validate_sms_params)
        config.add_show_tools_partial(:citation,
                                      icon: 'fa fa-quote-left',
                                      if: true)
        config.add_show_tools_partial(:ris,
                                      icon: 'fa fa-download',
                                      if: :render_ris_action?,
                                      modal: false,
                                      path: :ris_path)
        config.add_show_tools_partial(:refworks,
                                      icon: 'fa fa-list',
                                      if: :render_refworks_action?,
                                      new_window: true,
                                      modal: false,
                                      path: :refworks_path)
        config.add_show_tools_partial(:share_bookmarks,
                                      icon: 'fa fa-share',
                                      if: :render_sharebookmarks_action?,
                                      new_window: false,
                                      modal: false,
                                      path: :sharebookmarks_path)
        config.add_show_tools_partial(:bookmark,
                                      partial: 'bookmark_control',
                                      if: :render_bookmarks_control?)


        # default advanced config values
        config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
        # BL7
        config.advanced_search.enabled = true
        config.advanced_search[:url_key] ||= 'advanced'
        config.advanced_search[:form_solr_parameters] ||= {
          # NOTE: You will not get any facets back
          #       on the advanced search page
          #       unless defType is set to lucene.
          'defType' => 'lucene',
          'facet.field' => [TrlnArgon::Fields::AVAILABLE_FACET.to_s,
                            TrlnArgon::Fields::ACCESS_TYPE_FACET.to_s,
                            TrlnArgon::Fields::RESOURCE_TYPE_FACET.to_s,
                            TrlnArgon::Fields::LANGUAGE_FACET.to_s,
                            TrlnArgon::Fields::DATE_CATALOGED_FACET.to_s],
          'f.resource_type_f.facet.limit' => -1, # return all resource type values
          'f.language_f.facet.limit' => -1, # return all language facet values
          'f.date_cataloged_dt.facet.limit' => -1, # return all date facet values
          'facet.limit' => -1, # return all facet values
          'facet.sort' => 'index' # sort by byte order of values
        }

        config.index.title_field = TrlnArgon::Fields::TITLE_MAIN.to_s
        config.index.display_type_field = TrlnArgon::Fields::RESOURCE_TYPE.to_s

        # Facets to be populated on landing page
        config.add_home_facet_field TrlnArgon::Fields::ACCESS_TYPE_FACET.to_s,
                                    label: TrlnArgon::Fields::ACCESS_TYPE_FACET.label,
                                    collapse: false,
                                    show: true,
                                    partial: 'catalog/facet_checkbox',
                                    locals: { checkbox_field: 'Online', checkbox_field_label: I18n.t('trln_argon.checkbox_facets.online') }
        config.add_home_facet_field TrlnArgon::Fields::AVAILABLE_FACET.to_s,
                                    label: TrlnArgon::Fields::AVAILABLE_FACET.label,
                                    limit: true,
                                    collapse: false,
                                    show: true
        config.add_home_facet_field TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.to_s,
                                    label: TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.label,
                                    limit: -1,
                                    sort: 'count',
                                    collapse: false,
                                    ex: :rollup,
                                    # This helper is still needed for the label in constraints
                                    helper_method: :location_filter_display,
                                    component: Blacklight::Hierarchy::FacetFieldListComponent
        config.add_home_facet_field TrlnArgon::Fields::RESOURCE_TYPE_FACET.to_s,
                                    label: TrlnArgon::Fields::RESOURCE_TYPE_FACET.label,
                                    limit: true,
                                    collapse: false
        config.add_home_facet_field TrlnArgon::Fields::CALL_NUMBER_FACET.to_s,
                                    label: TrlnArgon::Fields::CALL_NUMBER_FACET.label,
                                    limit: 4500,
                                    sort: 'alpha',
                                    # This helper is still needed for the label in constraints
                                    helper_method: :call_number_filter_display,
                                    component: Blacklight::Hierarchy::FacetFieldListComponent
        config.add_home_facet_field TrlnArgon::Fields::LANGUAGE_FACET.to_s,
                                    label: TrlnArgon::Fields::LANGUAGE_FACET.label,
                                    limit: true
        config.add_home_facet_field TrlnArgon::Fields::DATE_CATALOGED_FACET.to_s,
                                    query: {
                                      'last_week' => { label: I18n.t('trln_argon.new_title_ranges.now_minus_week'),
                                                       fq: "#{TrlnArgon::Fields::DATE_CATALOGED_FACET}:[NOW-7DAY/DAY TO NOW]" },
                                      'last_month' => { label: I18n.t('trln_argon.new_title_ranges.now_minus_month'),
                                                        fq: "#{TrlnArgon::Fields::DATE_CATALOGED_FACET}:[NOW-1MONTH/DAY TO NOW]" },
                                      'last_three_months' => { label: I18n.t('trln_argon.new_title_ranges.now_minus_three_months'),
                                                               fq: "#{TrlnArgon::Fields::DATE_CATALOGED_FACET}:[NOW-3MONTH/DAY TO NOW]" }
                                    },
                                    label: TrlnArgon::Fields::DATE_CATALOGED_FACET.label,
                                    limit: true

        # Facets to be populated when search performed
        config.add_facet_field TrlnArgon::Fields::ACCESS_TYPE_FACET.to_s,
                               label: TrlnArgon::Fields::ACCESS_TYPE_FACET.label,
                               collapse: false,
                               show: true,
                               partial: 'catalog/facet_checkbox',
                               locals: { checkbox_field: 'Online', checkbox_field_label: I18n.t('trln_argon.checkbox_facets.online') },
                               advanced_search_component: TrlnArgon::AdvancedSearchFacetFieldComponent
        config.add_facet_field TrlnArgon::Fields::AVAILABLE_FACET.to_s,
                               label: TrlnArgon::Fields::AVAILABLE_FACET.label,
                               limit: true,
                               collapse: false,
                               show: true,
                               advanced_search_component: TrlnArgon::AdvancedSearchFacetFieldComponent
        config.add_facet_field TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.to_s,
                               label: TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.label,
                               limit: -1,
                               sort: 'count',
                               collapse: false,
                               ex: :rollup,
                               # This helper is still needed for the label in constraints
                               helper_method: :location_filter_display,
                               component: Blacklight::Hierarchy::FacetFieldListComponent,
                               advanced_search_component: TrlnArgon::AdvancedSearchFacetFieldComponent
        config.add_facet_field TrlnArgon::Fields::RESOURCE_TYPE_FACET.to_s,
                               label: TrlnArgon::Fields::RESOURCE_TYPE_FACET.label,
                               limit: true,
                               collapse: false,
                               advanced_search_component: TrlnArgon::AdvancedSearchFacetFieldComponent
        config.add_facet_field TrlnArgon::Fields::PHYSICAL_MEDIA_FACET.to_s,
                               label: TrlnArgon::Fields::PHYSICAL_MEDIA_FACET.label,
                               limit: true,
                               collapse: false,
                               advanced_search_component: TrlnArgon::AdvancedSearchFacetFieldComponent
        config.add_facet_field TrlnArgon::Fields::SUBJECT_TOPICAL_FACET.to_s,
                               label: TrlnArgon::Fields::SUBJECT_TOPICAL_FACET.label,
                               limit: true,
                               collapse: false,
                               advanced_search_component: TrlnArgon::AdvancedSearchFacetFieldComponent
        config.add_facet_field TrlnArgon::Fields::CALL_NUMBER_FACET.to_s,
                               label: TrlnArgon::Fields::CALL_NUMBER_FACET.label,
                               limit: 4500,
                               sort: 'alpha',
                               # This helper is still needed for the label in constraints
                               helper_method: :call_number_filter_display,
                               component: Blacklight::Hierarchy::FacetFieldListComponent,
                               advanced_search_component: TrlnArgon::AdvancedSearchFacetFieldComponent
        config.add_facet_field TrlnArgon::Fields::LANGUAGE_FACET.to_s,
                               label: TrlnArgon::Fields::LANGUAGE_FACET.label,
                               limit: true,
                               advanced_search_component: TrlnArgon::AdvancedSearchFacetFieldComponent
        config.add_facet_field TrlnArgon::Fields::PUBLICATION_YEAR_SORT.to_s,
                               label: TrlnArgon::Fields::PUBLICATION_YEAR_SORT.label,
                               single: true,
                               range: {
                                 assumed_boundaries: [1100, Time.now.year + 1],
                                 segments: false
                               },
                               advanced_search_component: TrlnArgon::AdvancedSearchRangeLimitComponent
        config.add_facet_field TrlnArgon::Fields::AUTHOR_FACET.to_s,
                               label: TrlnArgon::Fields::AUTHOR_FACET.label,
                               limit: true

        config.add_facet_field TrlnArgon::Fields::SUBJECT_GENRE_FACET.to_s,
                               label: TrlnArgon::Fields::SUBJECT_GENRE_FACET.label,
                               limit: true

        config.add_facet_field TrlnArgon::Fields::SUBJECT_GEOGRAPHIC_FACET.to_s,
                               label: TrlnArgon::Fields::SUBJECT_GEOGRAPHIC_FACET.label,
                               limit: true
        config.add_facet_field TrlnArgon::Fields::SUBJECT_CHRONOLOGICAL_FACET.to_s,
                               label: TrlnArgon::Fields::SUBJECT_CHRONOLOGICAL_FACET.label,
                               limit: true
        config.add_facet_field TrlnArgon::Fields::DATE_CATALOGED_FACET.to_s,
                               query: { 'last_week' => { label: I18n.t('trln_argon.new_title_ranges.now_minus_week'),
                                                         fq: "#{TrlnArgon::Fields::DATE_CATALOGED_FACET}:[NOW-7DAY/DAY TO NOW]" },
                                        'last_month' => { label: I18n.t('trln_argon.new_title_ranges.now_minus_month'),
                                                          fq: "#{TrlnArgon::Fields::DATE_CATALOGED_FACET}:[NOW-1MONTH/DAY TO NOW]" },
                                        'last_three_months' => { label: I18n.t('trln_argon.new_title_ranges.now_minus_three_months'),
                                                                 fq: "#{TrlnArgon::Fields::DATE_CATALOGED_FACET}:[NOW-3MONTH/DAY TO NOW]" } },
                               label: TrlnArgon::Fields::DATE_CATALOGED_FACET.label,
                               limit: true,
                               advanced_search_component: TrlnArgon::AdvancedSearchFacetFieldComponent

        # Hierarchical facet configuration
        # See: https://github.com/trln/blacklight-hierarchy/blob/main/README.md
        config.facet_display ||= {}
        cnf_components = TrlnArgon::Fields::CALL_NUMBER_FACET.to_s.split('_')
        lf_components = TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.to_s.split('_')
        config.facet_display[:hierarchy] = {
          # blacklight-hierarchy gem requires this mapping;
          # prefix + final component (separated by _) e.g.,
          #   'location_hierarchy' => [['f'], ':']
          # TRLN CUSTOMIZATION adds an optional third element to specify
          # a custom FacetItemPresenter.
          cnf_components[0..-2].join('_') => [[cnf_components[-1]],
                                              '|'],
          lf_components[0..-2].join('_') => [[lf_components[-1]],
                                             ':',
                                             TrlnArgon::LocationFacetItemPresenter]
        }

        # solr debug fields to be displayed in the index (search results) view
        # when debug=true is present in the request.
        config.add_index_field TrlnArgon::Fields::SCORE.to_s,
                               helper_method: :relevance_score
        config.add_index_field TrlnArgon::Fields::ID.to_s,
                               helper_method: :solr_document_request

        # solr fields to be displayed in the index (search results) view
        #   The ordering of the field names is the order of the display
        config.add_index_field TrlnArgon::Fields::STATEMENT_OF_RESPONSIBILITY.to_s,
                               accessor: :statement_of_responsibility
        config.add_index_field TrlnArgon::Fields::CREATOR_MAIN.to_s,
                               helper_method: :join_with_comma_semicolon_fallback
        config.add_index_field TrlnArgon::Fields::IMPRINT_MAIN.to_s,
                               accessor: :imprint_main_for_header_display
        config.add_index_field TrlnArgon::Fields::EDITION.to_s,
                               accessor: :edition
        config.add_index_field TrlnArgon::Fields::RESOURCE_TYPE.to_s,
                               helper_method: :join_with_comma_semicolon_fallback
        config.add_index_field TrlnArgon::Fields::PHYSICAL_MEDIA.to_s,
                               helper_method: :join_with_comma_semicolon_fallback

        # solr fields to be displayed in the show (single result) view
        #   The ordering of the field names is the order of the display
        config.add_show_field TrlnArgon::Fields::TITLE_VARIANT.to_s,
                              label: TrlnArgon::Fields::TITLE_VARIANT.label
        config.add_show_field TrlnArgon::Fields::TITLE_FORMER.to_s,
                              label: TrlnArgon::Fields::TITLE_FORMER.label
        config.add_show_field TrlnArgon::Fields::NOTE_FORMER_TITLE.to_s,
                              label: TrlnArgon::Fields::NOTE_FORMER_TITLE.label
        config.add_show_field TrlnArgon::Fields::SERIES_STATEMENT.to_s,
                              label: TrlnArgon::Fields::SERIES_STATEMENT.label
        config.add_show_field TrlnArgon::Fields::FREQUENCY_CURRENT.to_s,
                              label: TrlnArgon::Fields::FREQUENCY_CURRENT.label
        config.add_show_field TrlnArgon::Fields::FREQUENCY_FORMER.to_s,
                              label: TrlnArgon::Fields::FREQUENCY_FORMER.label
        config.add_show_field TrlnArgon::Fields::SECONDARY_URLS.to_s,
                              label: TrlnArgon::Fields::SECONDARY_URLS.label,
                              accessor: :secondary_urls,
                              helper_method: :link_to_secondary_urls
        config.add_show_field TrlnArgon::Fields::IMPRINT_MAIN.to_s,
                              label: TrlnArgon::Fields::IMPRINT_MULTIPLE.label,
                              accessor: :imprint_multiple_for_display
        config.add_show_field TrlnArgon::Fields::LANGUAGE.to_s,
                              label: TrlnArgon::Fields::LANGUAGE.label
        config.add_show_field TrlnArgon::Fields::NOTE_SERIAL_DATES.to_s,
                              label: TrlnArgon::Fields::NOTE_SERIAL_DATES.label
        config.add_show_field TrlnArgon::Fields::NOTE_ISSUANCE.to_s,
                              label: TrlnArgon::Fields::NOTE_ISSUANCE.label
        config.add_show_field TrlnArgon::Fields::NOTE_ORGANIZATION.to_s,
                              label: TrlnArgon::Fields::NOTE_ORGANIZATION.label
        config.add_show_field TrlnArgon::Fields::NOTE_RELATED_WORK.to_s,
                              label: TrlnArgon::Fields::NOTE_RELATED_WORK.label
        config.add_show_field TrlnArgon::Fields::NOTE_WITH.to_s,
                              label: TrlnArgon::Fields::NOTE_WITH.label
        config.add_show_field TrlnArgon::Fields::NOTE_DISSERTATION.to_s,
                              label: TrlnArgon::Fields::NOTE_DISSERTATION.label
        config.add_show_field TrlnArgon::Fields::NOTE_ACCESS_RESTRICTIONS.to_s,
                              label: TrlnArgon::Fields::NOTE_ACCESS_RESTRICTIONS.label
        config.add_show_field TrlnArgon::Fields::NOTE_USE_TERMS.to_s,
                              label: TrlnArgon::Fields::NOTE_USE_TERMS.label
        config.add_show_field TrlnArgon::Fields::NOTE_SCALE.to_s,
                              label: TrlnArgon::Fields::NOTE_SCALE.label
        config.add_show_field TrlnArgon::Fields::NOTE_PRODUCTION_CREDITS.to_s,
                              label: TrlnArgon::Fields::NOTE_PRODUCTION_CREDITS.label
        config.add_show_field TrlnArgon::Fields::NOTE_PERFORMER_CREDITS.to_s,
                              label: TrlnArgon::Fields::NOTE_PERFORMER_CREDITS.label
        config.add_show_field TrlnArgon::Fields::NOTE_REPORT_TYPE.to_s,
                              label: TrlnArgon::Fields::NOTE_REPORT_TYPE.label
        config.add_show_field TrlnArgon::Fields::NOTE_REPORT_COVERAGE.to_s,
                              label: TrlnArgon::Fields::NOTE_REPORT_COVERAGE.label
        config.add_show_field TrlnArgon::Fields::NOTE_DATA_QUALITY.to_s,
                              label: TrlnArgon::Fields::NOTE_DATA_QUALITY.label
        config.add_show_field TrlnArgon::Fields::NOTE_METHODOLOGY.to_s,
                              label: TrlnArgon::Fields::NOTE_METHODOLOGY.label
        config.add_show_field TrlnArgon::Fields::NOTE_NUMBERING.to_s,
                              label: TrlnArgon::Fields::NOTE_NUMBERING.label
        config.add_show_field TrlnArgon::Fields::NOTE_FILE_TYPE.to_s,
                              label: TrlnArgon::Fields::NOTE_FILE_TYPE.label
        config.add_show_field TrlnArgon::Fields::NOTE_SUPPLEMENT.to_s,
                              label: TrlnArgon::Fields::NOTE_SUPPLEMENT.label
        config.add_show_field TrlnArgon::Fields::NOTE_CITED_IN.to_s,
                              label: TrlnArgon::Fields::NOTE_CITED_IN.label
        config.add_show_field TrlnArgon::Fields::NOTE_DESCRIBED_BY.to_s,
                              label: TrlnArgon::Fields::NOTE_DESCRIBED_BY.label
        config.add_show_field TrlnArgon::Fields::NOTE_SYSTEM_DETAILS.to_s,
                              label: TrlnArgon::Fields::NOTE_SYSTEM_DETAILS.label
        config.add_show_field TrlnArgon::Fields::NOTE_ADMIN_HISTORY.to_s,
                              label: TrlnArgon::Fields::NOTE_ADMIN_HISTORY.label
        config.add_show_field TrlnArgon::Fields::NOTE_BIOGRAPHICAL.to_s,
                              label: TrlnArgon::Fields::NOTE_BIOGRAPHICAL.label
        config.add_show_field TrlnArgon::Fields::NOTE_COPY_VERSION.to_s,
                              label: TrlnArgon::Fields::NOTE_COPY_VERSION.label
        config.add_show_field TrlnArgon::Fields::NOTE_BINDING.to_s,
                              label: TrlnArgon::Fields::NOTE_BINDING.label
        config.add_show_field TrlnArgon::Fields::NOTE_REPRODUCTION.to_s,
                              label: TrlnArgon::Fields::NOTE_REPRODUCTION.label
        config.add_show_field TrlnArgon::Fields::NOTE_GENERAL.to_s,
                              label: TrlnArgon::Fields::NOTE_GENERAL.label
        config.add_show_field TrlnArgon::Fields::NOTE_ACCESSIBILITY.to_s,
                              label: TrlnArgon::Fields::NOTE_ACCESSIBILITY.label
        config.add_show_field TrlnArgon::Fields::NOTE_LOCAL.to_s,
                              label: TrlnArgon::Fields::NOTE_LOCAL.label,
                              helper_method: :clean_and_format_links
        config.add_show_field TrlnArgon::Fields::NOTE_PREFERRED_CITATION.to_s,
                              label: TrlnArgon::Fields::NOTE_PREFERRED_CITATION.label
        config.add_show_field TrlnArgon::Fields::PHYSICAL_DESCRIPTION.to_s,
                              label: TrlnArgon::Fields::PHYSICAL_DESCRIPTION.label
        config.add_show_field TrlnArgon::Fields::PHYSICAL_DESCRIPTION_DETAILS.to_s,
                              label: TrlnArgon::Fields::PHYSICAL_DESCRIPTION_DETAILS.label
        config.add_show_field TrlnArgon::Fields::GENRE_HEADINGS.to_s,
                              label: TrlnArgon::Fields::GENRE_HEADINGS.label,
                              accessor: :genre_headings,
                              helper_method: :list_of_linked_genres_segments
        config.add_show_field TrlnArgon::Fields::ISBN_WITH_QUALIFYING_INFO.to_s,
                              label: TrlnArgon::Fields::ISBN_WITH_QUALIFYING_INFO.label,
                              accessor: :isbn_with_qualifying_info
        config.add_show_field TrlnArgon::Fields::ISSN_LINKING.to_s,
                              label: TrlnArgon::Fields::ISSN_LINKING.label,
                              accessor: :issn
        config.add_show_field TrlnArgon::Fields::OCLC_NUMBER.to_s,
                              label: TrlnArgon::Fields::OCLC_NUMBER.label
        config.add_show_field TrlnArgon::Fields::MISC_ID.to_s,
                              label: TrlnArgon::Fields::MISC_ID.label
        config.add_show_field TrlnArgon::Fields::UPC.to_s,
                              label: TrlnArgon::Fields::UPC.label

        config.add_show_sub_header_field TrlnArgon::Fields::ID.to_s,
                                         helper_method: :solr_document_request
        config.add_show_sub_header_field TrlnArgon::Fields::STATEMENT_OF_RESPONSIBILITY.to_s,
                                         accessor: :statement_of_responsibility
        config.add_show_sub_header_field TrlnArgon::Fields::CREATOR_MAIN.to_s,
                                         helper_method: :join_with_comma_semicolon_fallback
        config.add_show_sub_header_field TrlnArgon::Fields::IMPRINT_MAIN.to_s,
                                         accessor: :imprint_main_for_header_display
        config.add_show_sub_header_field TrlnArgon::Fields::EDITION.to_s,
                                         accessor: :edition
        config.add_show_sub_header_field TrlnArgon::Fields::RESOURCE_TYPE.to_s,
                                         helper_method: :join_with_comma_semicolon_fallback
        config.add_show_sub_header_field TrlnArgon::Fields::PHYSICAL_MEDIA.to_s,
                                         helper_method: :join_with_comma_semicolon_fallback

        config.add_show_authors_field TrlnArgon::Fields::NAMES.to_s,
                                      label: TrlnArgon::Fields::NAMES.label,
                                      accessor: :names,
                                      helper_method: :names_display

        config.add_show_included_works_field TrlnArgon::Fields::INCLUDED_WORK.to_s,
                                             label: TrlnArgon::Fields::INCLUDED_WORK.label,
                                             accessor: :included_work,
                                             helper_method: :included_works_display

        config.add_show_related_works_field TrlnArgon::Fields::RELATED_WORK.to_s,
                                            label: TrlnArgon::Fields::RELATED_WORK.label,
                                            accessor: :related_work,
                                            helper_method: :work_entry_display
        config.add_show_related_works_field TrlnArgon::Fields::THIS_WORK.to_s,
                                            label: TrlnArgon::Fields::THIS_WORK.label,
                                            accessor: :this_work,
                                            helper_method: :work_entry_display
        config.add_show_related_works_field TrlnArgon::Fields::SERIES_WORK.to_s,
                                            label: TrlnArgon::Fields::SERIES_WORK.label,
                                            accessor: :series_work,
                                            helper_method: :work_entry_display
        config.add_show_related_works_field TrlnArgon::Fields::TRANSLATION_OF_WORK.to_s,
                                            label: TrlnArgon::Fields::TRANSLATION_OF_WORK.label,
                                            accessor: :translation_of_work,
                                            helper_method: :work_entry_display
        config.add_show_related_works_field TrlnArgon::Fields::TRANSLATED_AS_WORK.to_s,
                                            label: TrlnArgon::Fields::TRANSLATED_AS_WORK.label,
                                            accessor: :translated_as_work,
                                            helper_method: :work_entry_display
        config.add_show_related_works_field TrlnArgon::Fields::HAS_SUPPLEMENT_WORK.to_s,
                                            label: TrlnArgon::Fields::HAS_SUPPLEMENT_WORK.label,
                                            accessor: :has_supplement_work,
                                            helper_method: :work_entry_display
        config.add_show_related_works_field TrlnArgon::Fields::HOST_ITEM_WORK.to_s,
                                            label: TrlnArgon::Fields::HOST_ITEM_WORK.label,
                                            accessor: :host_item_work,
                                            helper_method: :work_entry_display
        config.add_show_related_works_field TrlnArgon::Fields::ALT_EDITION_WORK.to_s,
                                            label: TrlnArgon::Fields::ALT_EDITION_WORK.label,
                                            accessor: :alt_edition_work,
                                            helper_method: :work_entry_display
        config.add_show_related_works_field TrlnArgon::Fields::ISSUED_WITH_WORK.to_s,
                                            label: TrlnArgon::Fields::ISSUED_WITH_WORK.label,
                                            accessor: :issued_with_work,
                                            helper_method: :work_entry_display
        config.add_show_related_works_field TrlnArgon::Fields::EARLIER_WORK.to_s,
                                            label: TrlnArgon::Fields::EARLIER_WORK.label,
                                            accessor: :earlier_work,
                                            helper_method: :work_entry_display
        config.add_show_related_works_field TrlnArgon::Fields::LATER_WORK.to_s,
                                            label: TrlnArgon::Fields::LATER_WORK.label,
                                            accessor: :later_work,
                                            helper_method: :work_entry_display
        config.add_show_related_works_field TrlnArgon::Fields::DATA_SOURCE_WORK.to_s,
                                            label: TrlnArgon::Fields::DATA_SOURCE_WORK.label,
                                            accessor: :data_source_work,
                                            helper_method: :work_entry_display

        config.add_show_subjects_field TrlnArgon::Fields::SUBJECT_HEADINGS.to_s,
                                       accessor: :subject_headings,
                                       helper_method: :list_of_linked_subjects_segments

        # "fielded" search configuration. Used by pulldown among other places.
        # For supported keys in hash, see rdoc for Blacklight::SearchFields
        #
        # Search fields will inherit the :qt solr request handler from
        # config[:default_solr_parameters], OR can specify a different one
        # with a :qt key/value. Below examples inherit, except for subject
        # that specifies the same :qt as default for our own internal
        # testing purposes.
        #
        # The :key is what will be used to identify this BL search field internally,
        # as well as in URLs -- so changing it after deployment may break bookmarked
        # urls.  A display label will be automatically calculated from the :key,
        # or can be specified manually to be different.

        # This one uses all the defaults set by the solr request handler. Which
        # solr request handler? The one set in config[:default_solr_parameters][:qt],
        # since we aren't specifying it otherwise.

        config.add_search_field 'all_fields',
                                label: I18n.t('trln_argon.search_fields.all_fields')

        config.add_search_field('title') do |field|
          field.label = I18n.t('trln_argon.search_fields.title')
          field.def_type = 'edismax'
          field.solr_local_parameters = {
            qf:  '$title_qf',
            pf:  '$title_pf',
            pf3: '$title_pf3',
            pf2: '$title_pf2'
          }
        end

        config.add_search_field('author') do |field|
          field.label = I18n.t('trln_argon.search_fields.author')
          field.def_type = 'edismax'
          field.solr_local_parameters = {
            qf:  '$author_qf',
            pf:  '$author_pf',
            pf3: '$author_pf3',
            pf2: '$author_pf2'
          }
        end

        config.add_search_field('subject') do |field|
          field.label = I18n.t('trln_argon.search_fields.subject')
          field.def_type = 'edismax'
          field.solr_local_parameters = {
            qf:  '$subject_qf',
            pf:  '$subject_pf',
            pf3: '$subject_pf3',
            pf2: '$subject_pf2'
          }
        end

        config.add_search_field('publisher') do |field|
          field.include_in_simple_select = false
          field.label = I18n.t('trln_argon.search_fields.publisher')
          field.def_type = 'edismax'
          field.solr_parameters = {
            qf:  '$publisher_qf',
            pf:  '$publisher_pf',
            pf3: '',
            pf2: ''
          }
        end

        config.add_search_field('series_statement') do |field|
          field.include_in_simple_select = false
          field.label = I18n.t('trln_argon.search_fields.series')
          field.def_type = 'edismax'
          field.solr_local_parameters = {
            qf:  '$series_qf',
            pf:  '$series_pf',
            pf3: '$series_pf3',
            pf2: '$series_pf2'
          }
        end

        config.add_search_field('isbn_issn') do |field|
          field.label = I18n.t('trln_argon.search_fields.isbn_issn')
          field.def_type = 'edismax'
          field.solr_local_parameters = {
            qf:  '$isbn_issn_qf',
            pf:  '',
            pf3: '',
            pf2: ''
          }
        end

        config.add_search_field('genre_headings') do |field|
          field.label = I18n.t('trln_argon.search_fields.genre_headings')
          field.def_type = 'edismax'
          field.solr_local_parameters = {
            qf:  'genre_headings_t genre_headings_ara_v genre_headings_cjk_v genre_headings_rus_v',
            pf:  '',
            pf3: '',
            pf2: ''
          }
          field.if = false
          field.include_in_advanced_search = false
        end

        config.add_search_field('work_entry') do |field|
          field.label = I18n.t('trln_argon.search_fields.work_entry')
          field.def_type = 'edismax'
          field.solr_local_parameters = {
            qf:  '$work_entry_qf',
            pf:  '$work_entry_pf',
            pf3: '',
            pf2: ''
          }
          field.if = false
          field.include_in_advanced_search = false
        end

        # "sort results by" select (pulldown)
        # label in pulldown is followed by the name of the SOLR field to sort by and
        # whether the sort is ascending or descending (it must be asc or desc
        # except in the relevancy case).
        config.add_sort_field 'score desc, '\
                              "#{TrlnArgon::Fields::PUBLICATION_YEAR_SORT} desc, "\
                              "#{TrlnArgon::Fields::TITLE_SORT} asc",
                              label: I18n.t('trln_argon.sort_options.relevance')

        config.add_sort_field "#{TrlnArgon::Fields::PUBLICATION_YEAR_SORT} desc, "\
                              'score desc, '\
                              "#{TrlnArgon::Fields::TITLE_SORT} asc",
                              label: I18n.t('trln_argon.sort_options.year_desc')

        config.add_sort_field "#{TrlnArgon::Fields::PUBLICATION_YEAR_SORT} asc, "\
                              'score desc, '\
                              "#{TrlnArgon::Fields::TITLE_SORT} asc",
                              label: I18n.t('trln_argon.sort_options.year_asc')

        # config.add_sort_field "#{TrlnArgon::Fields::AUTHOR_SORT} asc, "\
        #                       "#{TrlnArgon::Fields::TITLE_SORT} asc",
        #                       label: I18n.t('trln_argon.sort_options.author_asc')

        config.add_sort_field "#{TrlnArgon::Fields::TITLE_SORT} asc, "\
                              "#{TrlnArgon::Fields::PUBLICATION_YEAR_SORT} asc",
                              label: I18n.t('trln_argon.sort_options.title_asc')

        # config.add_sort_field "#{TrlnArgon::Fields::TITLE_SORT} desc, "\
        #                       "#{TrlnArgon::Fields::PUBLICATION_YEAR_SORT} asc",
        #                       label: I18n.t('trln_argon.sort_options.title_desc')
      end

      # Override default Blacklight index action to add caching
      # See behavior in lib/controller_override/solr_caching_catalog.rb
      def index
        cached_catalog_index
      end

      # Override behavior
      # returns solr_response and documents
      def action_documents
        # Code borrowed from [blacklight]/app/services/blacklight/search_service.rb
        solr_response = search_service.repository.find params[:id]
        # Not sure if we need to set @documents in this context (d.croney)
        @documents = solr_response.documents
        [solr_response, solr_response.documents]
      end

      # rubocop:disable Naming/PredicateName
      def has_search_parameters?
        %i[q f op seach_field range doc_ids].any? { |p| params[p].present? }
        # rubocop:enable Naming/PredicateName
      end

      def query_has_constraints?(localized_params = params)
        if is_advanced_search? localized_params
          true
        else
          !(localized_params[:q].blank? &&
            localized_params[:f].blank? &&
            localized_params[:f_inclusive].blank? &&
            localized_params[:range].blank? &&
            localized_params[:doc_ids].blank?)
        end
      end

      # rubocop:disable Naming/PredicateName
      def is_advanced_search?(req_params = params)
        (req_params[:search_field] == blacklight_config.advanced_search[:url_key]) ||
          req_params[:f_inclusive]
      end
      # rubocop:enable Naming/PredicateName

      def render_ris_action?
        doc = @document || (@document_list || []).first
        doc && doc.respond_to?(:export_formats) && doc.export_formats.keys.include?(:ris)
      end

      alias_method :render_refworks_action?, :render_ris_action?

      def render_sharebookmarks_action?(_config, _options)
        true if request.path == bookmarks_path
      end

      def render_citation_action?
        docs = [@document || (@document_list || [])].flatten
        TrlnArgon::Engine.configuration.citation_formats.present? &&
          TrlnArgon::Engine.configuration.worldcat_cite_base_url.present? &&
          TrlnArgon::Engine.configuration.worldcat_cite_api_key.present? &&
          docs.select { |doc| doc.oclc_number.present? }.any?
      end

      def log_params
        params.permit(:lines)
      end

      def logs
        return unless TrlnArgon::Engine.configuration.allow_tracebacks.present?
        lines = log_params.fetch(:lines, 50)
        return unless lines.to_s.match(/\d+/)
        @logs = `tail -n #{lines} log/#{Rails.env}.log`
      end
    end
  end
end
