require 'trln_argon/controller_override/local_filter'

module TrlnArgon
  # Sets the default Blacklight configuration and
  # CatalogController behaviors for TRLN Argon based
  # applications. Override in the local application in
  # app/controllers/catalog_controller.rb
  module ControllerOverride
    extend ActiveSupport::Concern

    included do
      send(:include, LocalFilter)
      send(:include, BlacklightAdvancedSearch::Controller)

      helper_method :query_has_constraints?

      add_show_tools_partial(:email,
                             icon: 'glyphicon-envelope',
                             callback: :email_action,
                             path: :email_path,
                             validator: :validate_email_params)
      add_show_tools_partial(:sms,
                             icon: 'glyphicon-phone',
                             if: :render_sms_action?,
                             callback: :sms_action,
                             path: :sms_path,
                             validator: :validate_sms_params)
      add_show_tools_partial(:ris,
                             icon: 'glyphicon-download-alt',
                             if: :render_ris_action?,
                             modal: false,
                             path: :ris_path)
      add_show_tools_partial(:refworks,
                             icon: 'glyphicon-export',
                             if: :render_refworks_action?,
                             new_window: true,
                             modal: false,
                             path: :refworks_path)

      # TRLN Argon CatalogController configurations
      configure_blacklight do |config|
        config.search_builder_class = DefaultLocalSearchBuilder
        config.default_per_page = 20

        # Use Solr search requestHandler for search requests
        config.solr_path = :select

        # Use Solr document requestHandler for document requests
        config.document_solr_path = :document
        config.document_solr_request_handler = nil

        # Configuration for autocomplete suggester
        config.autocomplete_enabled = true
        config.autocomplete_solr_component = 'suggest'
        config.autocomplete_path = 'suggest'
        config.autocomplete_path_title = 'suggest_title'
        config.autocomplete_path_author = 'suggest_author'
        config.autocomplete_path_subject = 'suggest_subject'

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
        config.show.document_actions.delete(:citation)

        # Set partials to render
        config.index.partials = %i[index_header thumbnail index index_items]

        # default advanced config values
        config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
        config.advanced_search[:url_key] ||= 'advanced'
        config.advanced_search[:form_facet_partial] ||= 'advanced_search_facets_as_select'
        config.advanced_search[:form_solr_parameters] ||= {
          # NOTE: You will not get any facets back
          #       on the advanced search page
          #       unless defType is set to lucene.
          'defType' => 'lucene',
          'facet.field' => [TrlnArgon::Fields::AVAILABLE_FACET.to_s,
                            TrlnArgon::Fields::ACCESS_TYPE_FACET.to_s,
                            TrlnArgon::Fields::RESOURCE_TYPE_FACET.to_s,
                            TrlnArgon::Fields::LANGUAGE_FACET.to_s],
          'f.resource_type_f.facet.limit' => -1, # return all resource type values
          'f.language_f.facet.limit' => -1, # return all language facet values
          'facet.limit' => -1, # return all facet values
          'facet.sort' => 'index', # sort by byte order of values
          'facet.query' => ''
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
                                    limit: 200,
                                    sort: 'count',
                                    helper_method: :location_filter_display,
                                    partial: 'blacklight/hierarchy/facet_hierarchy',
                                    collapse: false
        config.add_home_facet_field TrlnArgon::Fields::RESOURCE_TYPE_FACET.to_s,
                                    label: TrlnArgon::Fields::RESOURCE_TYPE_FACET.label,
                                    limit: true,
                                    collapse: false
        # NOTE: Temporarily disabled due to need to regenerate/reindex all
        #       hierarchies in MTA using a pipe as the delimiter.
        # config.add_home_facet_field TrlnArgon::Fields::CALL_NUMBER_FACET.to_s,
        #                             label: TrlnArgon::Fields::CALL_NUMBER_FACET.label,
        #                             limit: 4000,
        #                             partial: 'blacklight/hierarchy/facet_hierarchy'
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
                               locals: { checkbox_field: 'Online', checkbox_field_label: I18n.t('trln_argon.checkbox_facets.online') }
        config.add_facet_field TrlnArgon::Fields::AVAILABLE_FACET.to_s,
                               label: TrlnArgon::Fields::AVAILABLE_FACET.label,
                               limit: true,
                               collapse: false,
                               show: true
        config.add_facet_field TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.to_s,
                               label: TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.label,
                               limit: 200,
                               sort: 'count',
                               helper_method: :location_filter_display,
                               partial: 'blacklight/hierarchy/facet_hierarchy',
                               collapse: false
        config.add_facet_field TrlnArgon::Fields::RESOURCE_TYPE_FACET.to_s,
                               label: TrlnArgon::Fields::RESOURCE_TYPE_FACET.label,
                               limit: true,
                               collapse: false
        config.add_facet_field TrlnArgon::Fields::PHYSICAL_MEDIA_FACET.to_s,
                               label: TrlnArgon::Fields::PHYSICAL_MEDIA_FACET.label,
                               limit: true,
                               collapse: false
        config.add_facet_field TrlnArgon::Fields::SUBJECT_TOPICAL_FACET.to_s,
                               label: TrlnArgon::Fields::SUBJECT_TOPICAL_FACET.label,
                               limit: true,
                               collapse: false
        # NOTE: Temporarily disabled due to need to regenerate/reindex all
        #       hierarchies in MTA using a pipe as the delimiter.
        # config.add_facet_field TrlnArgon::Fields::CALL_NUMBER_FACET.to_s,
        #                        label: TrlnArgon::Fields::CALL_NUMBER_FACET.label,
        #                        limit: 4000,
        #                        partial: 'blacklight/hierarchy/facet_hierarchy'
        config.add_facet_field TrlnArgon::Fields::LANGUAGE_FACET.to_s,
                               label: TrlnArgon::Fields::LANGUAGE_FACET.label,
                               limit: true
        config.add_facet_field TrlnArgon::Fields::PUBLICATION_YEAR_SORT.to_s,
                               label: TrlnArgon::Fields::PUBLICATION_YEAR_SORT.label,
                               single: true,
                               range: {
                                 assumed_boundaries: [1100, Time.now.year + 1],
                                 segments: false
                               }
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
                               limit: true

        # hierarchical facet configuration
        config.facet_display ||= {}
        cnf_components = TrlnArgon::Fields::CALL_NUMBER_FACET.to_s.split('_')
        lf_components = TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.to_s.split('_')
        config.facet_display[:hierarchy] = {
          # blacklight-hierarchy requires this mapping;
          # prefix + final component (separated by _)
          cnf_components[0..-2].join('_') => [[cnf_components[-1]], '|'],
          lf_components[0..-2].join('_') => [[lf_components[-1]], ':']
        }

        # solr fields to be displayed in the index (search results) view
        #   The ordering of the field names is the order of the display
        config.add_index_field TrlnArgon::Fields::STATEMENT_OF_RESPONSIBILITY.to_s,
                               accessor: :statement_of_responsibility
        config.add_index_field TrlnArgon::Fields::IMPRINT_MAIN.to_s,
                               accessor: :imprint_main_for_header_display
        config.add_index_field TrlnArgon::Fields::EDITION.to_s,
                               accessor: :edition
        config.add_index_field TrlnArgon::Fields::RESOURCE_TYPE.to_s,
                               helper_method: :join_with_commas
        config.add_index_field TrlnArgon::Fields::PHYSICAL_MEDIA.to_s,
                               helper_method: :join_with_commas

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
        config.add_show_field TrlnArgon::Fields::NOTE_LOCAL.to_s,
                              label: TrlnArgon::Fields::NOTE_LOCAL.label
        config.add_show_field TrlnArgon::Fields::PHYSICAL_DESCRIPTION.to_s,
                              label: TrlnArgon::Fields::PHYSICAL_DESCRIPTION.label
        config.add_show_field TrlnArgon::Fields::PHYSICAL_DESCRIPTION_DETAILS.to_s,
                              label: TrlnArgon::Fields::PHYSICAL_DESCRIPTION_DETAILS.label
        config.add_show_field TrlnArgon::Fields::GENRE_HEADINGS.to_s,
                              label: TrlnArgon::Fields::GENRE_HEADINGS.label,
                              accessor: :genre_headings,
                              helper_method: :link_to_fielded_keyword_search,
                              search_field: :genre_headings
        config.add_show_field TrlnArgon::Fields::ISBN_WITH_QUALIFYING_INFO.to_s,
                              label: TrlnArgon::Fields::ISBN_WITH_QUALIFYING_INFO.label,
                              accessor: :isbn_with_qualifying_info
        config.add_show_field TrlnArgon::Fields::ISSN_LINKING.to_s,
                              label: TrlnArgon::Fields::ISSN_LINKING.label
        config.add_show_field TrlnArgon::Fields::OCLC_NUMBER.to_s,
                              label: TrlnArgon::Fields::OCLC_NUMBER.label
        config.add_show_field TrlnArgon::Fields::MISC_ID.to_s,
                              label: TrlnArgon::Fields::MISC_ID.label
        config.add_show_field TrlnArgon::Fields::UPC.to_s,
                              label: TrlnArgon::Fields::UPC.label

        config.add_show_sub_header_field TrlnArgon::Fields::STATEMENT_OF_RESPONSIBILITY.to_s,
                                         accessor: :statement_of_responsibility
        config.add_show_sub_header_field TrlnArgon::Fields::IMPRINT_MAIN.to_s,
                                         accessor: :imprint_main_for_header_display
        config.add_show_sub_header_field TrlnArgon::Fields::EDITION.to_s,
                                         accessor: :edition
        config.add_show_sub_header_field TrlnArgon::Fields::RESOURCE_TYPE.to_s,
                                         helper_method: :join_with_commas
        config.add_show_sub_header_field TrlnArgon::Fields::PHYSICAL_MEDIA.to_s,
                                         helper_method: :join_with_commas

        config.add_show_authors_field TrlnArgon::Fields::NAMES.to_s,
                                      label: TrlnArgon::Fields::NAMES.label,
                                      accessor: :names,
                                      helper_method: :names_display

        config.add_show_included_works_field TrlnArgon::Fields::INCLUDED_WORK.to_s,
                                             label: TrlnArgon::Fields::INCLUDED_WORK.label,
                                             accessor: :included_work,
                                             helper_method: :work_entry_display

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
            qf: '$title_qf',
            pf: '$title_pf'
          }
        end

        config.add_search_field('author') do |field|
          field.label = I18n.t('trln_argon.search_fields.author')
          field.def_type = 'edismax'
          field.solr_local_parameters = {
            qf: '$author_qf',
            pf: '$author_pf'
          }
        end

        config.add_search_field('subject') do |field|
          field.label = I18n.t('trln_argon.search_fields.subject')
          field.def_type = 'edismax'
          field.solr_local_parameters = {
            qf: '$subject_qf',
            pf: '$subject_pf'
          }
        end

        config.add_search_field('publisher') do |field|
          field.include_in_simple_select = false
          field.label = I18n.t('trln_argon.search_fields.publisher')
          field.def_type = 'edismax'
          field.solr_parameters = {
            qf: '$publisher_qf',
            pf: '$publisher_pf'
          }
        end

        config.add_search_field('isbn_issn') do |field|
          field.label = I18n.t('trln_argon.search_fields.isbn_issn')
          field.def_type = 'edismax'
          field.solr_local_parameters = {
            qf: '$isbn_issn_qf'
          }
        end

        config.add_search_field('genre_headings') do |field|
          field.label = 'Genre'
          field.def_type = 'edismax'
          field.solr_local_parameters = {
            qf: 'genre_headings_t genre_headings_ara_v genre_headings_cjk_v genre_headings_rus_v'
          }
          field.if = false
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
                              "#{TrlnArgon::Fields::TITLE_SORT} asc",
                              label: I18n.t('trln_argon.sort_options.year_desc')

        config.add_sort_field "#{TrlnArgon::Fields::PUBLICATION_YEAR_SORT} asc, "\
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

      # rubocop:disable Style/PredicateName
      def has_search_parameters?
        !params[:q].blank? ||
          !params[:f].blank? ||
          !params[:search_field].blank? ||
          !params[:range].blank?
      end

      def query_has_constraints?(localized_params = params)
        if is_advanced_search? localized_params
          true
        else
          !(localized_params[:q].blank? &&
            localized_params[:f].blank? &&
            localized_params[:f_inclusive].blank? &&
            localized_params[:range].blank?)
        end
      end

      def render_ris_action?(_config, options = {})
        doc = options[:document] || (options[:document_list] || []).first
        doc && doc.respond_to?(:export_formats) && doc.export_formats.keys.include?(:ris)
      end

      alias_method :render_refworks_action?, :render_ris_action?
    end
  end
end
