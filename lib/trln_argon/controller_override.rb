module TrlnArgon
  # Sets the default Blacklight configuration and
  # CatalogController behaviors for TRLN Argon based
  # applications. Override in the local application in
  # app/controllers/catalog_controller.rb
  module ControllerOverride
    extend ActiveSupport::Concern

    included do
      send(:include, BlacklightAdvancedSearch::Controller)

      before_action :set_local_filter_param_to_default, only: :index

      before_action :filtered_results_total, only: :index

      helper_method :local_filter_applied?

      # TRLN Argon CatalogController configurations
      configure_blacklight do |config|
        config.search_builder_class = TrlnArgonSearchBuilder
        config.default_per_page = 20

        config.default_solr_params = {
          defType: 'edismax'
        }

        # Use Solr search requestHandler for search requests
        config.solr_path = :select

        # Use Solr document requestHandler for document requests
        config.document_solr_path = :document
        config.document_solr_request_handler = nil

        config.show.partials = %i[show_header show_thumbnail show show_items]

        # Set partials to render
        config.index.partials = %i[index_header thumbnail index index_items]

        # default advanced config values
        config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
        config.advanced_search[:url_key] ||= 'advanced'
        config.advanced_search[:query_parser] ||= 'edismax'
        config.advanced_search[:form_solr_parameters] ||= {}

        config.index.title_field = TrlnArgon::Fields::TITLE_MAIN.to_s

        config.index.display_type_field = TrlnArgon::Fields::FORMAT.to_s

        config.add_facet_field TrlnArgon::Fields::AVAILABLE_FACET.to_s,
                               label: TrlnArgon::Fields::AVAILABLE_FACET.label,
                               limit: true,
                               collapse: false
        config.add_facet_field TrlnArgon::Fields::INSTITUTION_FACET.to_s,
                               label: TrlnArgon::Fields::INSTITUTION_FACET.label,
                               limit: true,
                               collapse: false
        config.add_facet_field TrlnArgon::Fields::ITEMS_LOCATION_FACET.to_s,
                               label: TrlnArgon::Fields::ITEMS_LOCATION_FACET.label,
                               limit: true,
                               collapse: false
        config.add_facet_field TrlnArgon::Fields::FORMAT_FACET.to_s,
                               label: TrlnArgon::Fields::FORMAT_FACET.label,
                               limit: true,
                               collapse: false
        config.add_facet_field TrlnArgon::Fields::SUBJECT_TOPIC_LCSH_FACET.to_s,
                               label: TrlnArgon::Fields::SUBJECT_TOPIC_LCSH_FACET.label,
                               limit: true,
                               collapse: false
        config.add_facet_field TrlnArgon::Fields::SUBJECT_MEDICAL_FACET.to_s,
                               label: TrlnArgon::Fields::SUBJECT_MEDICAL_FACET.label,
                               limit: true
        config.add_facet_field TrlnArgon::Fields::CALL_NUMBER_FACET.to_s,
                               label: TrlnArgon::Fields::CALL_NUMBER_FACET.label,
                               partial: 'blacklight/hierarchy/facet_hierarchy'
        config.add_facet_field TrlnArgon::Fields::LANGUAGE_FACET.to_s,
                               label: TrlnArgon::Fields::LANGUAGE_FACET.label,
                               limit: true
        config.add_facet_field TrlnArgon::Fields::PUBLICATION_YEAR_SORT.to_s,
                               query: { '2000_to_present' =>
                                        { label: I18n.t('trln_argon.publication_year_ranges.2000_to_present'),
                                          q: "#{TrlnArgon::Fields::PUBLICATION_YEAR_SORT}:[2000 TO *]" },
                                        '1900_to_1999' =>
                                        { label: I18n.t('trln_argon.publication_year_ranges.1900_to_1999'),
                                          fq: "#{TrlnArgon::Fields::PUBLICATION_YEAR_SORT}:[1900 TO 1999]" },
                                        '1800_to_1899' =>
                                        { label: I18n.t('trln_argon.publication_year_ranges.1800_to_1899'),
                                          fq: "#{TrlnArgon::Fields::PUBLICATION_YEAR_SORT}:[1800 TO 1899]" },
                                        'before_1800' =>
                                        { label: I18n.t('trln_argon.publication_year_ranges.before_1800'),
                                          fq: "#{TrlnArgon::Fields::PUBLICATION_YEAR_SORT}:[* TO 1799]" } },
                               label: TrlnArgon::Fields::PUBLICATION_YEAR_SORT.label,
                               limit: true
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

        # hierarchical facet configuration
        config.facet_display ||= {}
        components = TrlnArgon::Fields::CALL_NUMBER_FACET.to_s.split('_')
        config.facet_display[:hierarchy] = {
          # blacklight-hiearchy requires this mapping;
          # prefix + final component (separated by _)
          components[0..-2].join('_') => [[components[-1]], ':']
        }

        # solr fields to be displayed in the index (search results) view
        #   The ordering of the field names is the order of the display
        config.add_index_field TrlnArgon::Fields::TITLE_MAIN_VERN.to_s,
                               label: TrlnArgon::Fields::TITLE_MAIN_VERN.label
        config.add_index_field TrlnArgon::Fields::AUTHORS_MAIN.to_s,
                               label: TrlnArgon::Fields::AUTHORS_MAIN.label
        config.add_index_field TrlnArgon::Fields::AUTHORS_MAIN_VERN.to_s,
                               label: TrlnArgon::Fields::AUTHORS_MAIN_VERN.label
        config.add_index_field TrlnArgon::Fields::FORMAT.to_s,
                               label: TrlnArgon::Fields::FORMAT.label
        config.add_index_field TrlnArgon::Fields::LANGUAGE.to_s,
                               label: TrlnArgon::Fields::LANGUAGE.label
        config.add_index_field TrlnArgon::Fields::PUBLISHER_ETC.to_s,
                               label: TrlnArgon::Fields::PUBLISHER_ETC.label
        config.add_index_field TrlnArgon::Fields::PUBLICATION_YEAR_SORT.to_s,
                               label: TrlnArgon::Fields::PUBLICATION_YEAR_SORT.label
        config.add_index_field TrlnArgon::Fields::INSTITUTION.to_s,
                               label: TrlnArgon::Fields::INSTITUTION.label,
                               helper_method: :institution_code_to_short_name
        config.add_index_field TrlnArgon::Fields::URL_HREF.to_s,
                               label: TrlnArgon::Fields::URL_HREF.label,
                               helper_method: :url_href_with_url_text_link

        # solr fields to be displayed in the show (single result) view
        #   The ordering of the field names is the order of the display
        config.add_show_field TrlnArgon::Fields::TITLE_MAIN.to_s,
                              label: TrlnArgon::Fields::TITLE_MAIN.label
        config.add_show_field TrlnArgon::Fields::AUTHORS_MAIN.to_s,
                              label: TrlnArgon::Fields::AUTHORS_MAIN.label
        config.add_show_field TrlnArgon::Fields::FORMAT.to_s,
                              label: TrlnArgon::Fields::FORMAT.label
        config.add_show_field TrlnArgon::Fields::LANGUAGE.to_s,
                              label: TrlnArgon::Fields::LANGUAGE.label
        config.add_show_field TrlnArgon::Fields::SUBJECTS.to_s,
                              label: TrlnArgon::Fields::SUBJECTS.label
        config.add_show_field TrlnArgon::Fields::PUBLISHER_ETC.to_s,
                              label: TrlnArgon::Fields::PUBLISHER_ETC.label
        config.add_show_field TrlnArgon::Fields::ISBN_NUMBER.to_s,
                              label: TrlnArgon::Fields::ISBN_NUMBER.label
        config.add_show_field TrlnArgon::Fields::PUBLICATION_YEAR_SORT.to_s,
                              label: TrlnArgon::Fields::PUBLICATION_YEAR_SORT.label
        config.add_show_field TrlnArgon::Fields::INSTITUTION.to_s,
                              label: TrlnArgon::Fields::INSTITUTION.label,
                              helper_method: :institution_code_to_short_name
        config.add_show_field TrlnArgon::Fields::URL_HREF.to_s,
                              label: TrlnArgon::Fields::URL_HREF.label,
                              helper_method: :url_href_with_url_text_link

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

        # Now we see how to over-ride Solr request handler defaults, in this
        # case for a BL "search field", which is really a dismax aggregate
        # of Solr search fields.

        config.add_search_field('title') do |field|
          # solr_parameters hash are sent to Solr as ordinary url query params.
          # field.solr_parameters = { :'spellcheck.dictionary' => 'title' }
          field.label = I18n.t('trln_argon.search_fields.title')

          # :solr_local_parameters will be sent using Solr LocalParams
          # syntax, as eg {! qf=$title_qf }. This is neccesary to use
          # Solr parameter de-referencing like $title_qf.
          # See: http://wiki.apache.org/solr/LocalParams
          field.solr_local_parameters = {
            qf: '$title_qf',
            pf: '$title_pf'
          }
        end

        config.add_search_field('author') do |field|
          field.label = I18n.t('trln_argon.search_fields.author')
          field.solr_local_parameters = {
            qf: '$author_qf',
            pf: '$author_pf'
          }
        end

        # Specifying a :qt only to show it's possible, and so our internal automated
        # tests can test it. In this case it's the same as
        # config[:default_solr_parameters][:qt], so isn't actually neccesary.
        config.add_search_field('subject') do |field|
          field.label = I18n.t('trln_argon.search_fields.subject')
          field.qt = 'search'
          field.solr_local_parameters = {
            qf: '$subject_qf',
            pf: '$subject_pf'
          }
        end

        config.add_search_field('isbn_issn') do |field|
          field.label = I18n.t('trln_argon.search_fields.isbn_issn')
          field.solr_local_parameters = {
            qf: '$isbn_issn_qf'
          }
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

        # config.add_sort_field "#{TrlnArgon::Fields::PUBLICATION_YEAR_SORT} asc, "\
        #                       "#{TrlnArgon::Fields::TITLE_SORT} asc",
        #                       label: I18n.t('trln_argon.sort_options.year_asc')

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

      def index
        super
        return if local_filter_applied?
        expanded_documents_hash
      end

      private

      def expanded_documents_hash
        @expanded_documents_hash ||= Hash[@response.documents.map { |doc| [doc.id, expanded_documents(doc)] }]
      end

      def expanded_documents(doc)
        group_docs = expanded_documents_response.group(TrlnArgon::Fields::ROLLUP_ID).groups.select do |group|
          group.key == doc[TrlnArgon::Fields::ROLLUP_ID]
        end.first
        group_docs = group_docs.respond_to?(:docs) ? group_docs.docs : [doc]
        Hash[group_docs.map do |gr_doc|
          [gr_doc[TrlnArgon::Fields::INSTITUTION].first,
           { availability: gr_doc.availability,
             url: gr_doc[TrlnArgon::Fields::URL_HREF] }]
        end]
      end

      def rollup_ids_from_response
        @rollup_ids_from_response ||= @response.documents.map do |doc|
          doc[TrlnArgon::Fields::ROLLUP_ID]
        end.compact.join(' ')
      end

      def expanded_documents_search_builder
        @expanded_documents_search_builder ||= SearchBuilder.new([:add_query_to_solr], self)
      end

      def expanded_documents_query
        @expanded_documents_query ||= expanded_documents_search_builder
                                      .where("_query_:\"{!q.op=OR df=#{TrlnArgon::Fields::ROLLUP_ID} v=$rollup_ids}\"")
                                      .merge(rollup_ids: rollup_ids_from_response,
                                             group: 'true',
                                             'group.field' => TrlnArgon::Fields::ROLLUP_ID,
                                             'group.limit' => '4',
                                             fl: "#{TrlnArgon::Fields::ID}, #{TrlnArgon::Fields::ROLLUP_ID}, "\
                                                 "#{TrlnArgon::Fields::INSTITUTION}, #{TrlnArgon::Fields::AVAILABLE}, "\
                                                 "#{TrlnArgon::Fields::URL_HREF}")
      end

      def expanded_documents_response
        @expanded_documents_response ||= repository.search(expanded_documents_query)
      end

      def filtered_results_total
        @filtered_results_total ||=
          filtered_results_query_response['response']['numFound']
      end

      def filtered_results_query_response
        repository.search(local_filter_search_builder
          .append(*additional_processor_chain_methods)
          .with(search_state.to_h))
      end

      # This is needed so that controllers that inherit from CatalogController
      # Will have any additional processor chain methods applied to the
      # query that fetches the local filter count
      def additional_processor_chain_methods
        search_builder.processor_chain -
          local_filter_search_builder.processor_chain -
          excluded_processor_chain_methods
      end

      def excluded_processor_chain_methods
        [:apply_local_filter]
      end

      def local_filter_search_builder
        @local_filter_search_builder ||=
          if local_filter_applied?
            ConsortiumSearchBuilder.new(CatalogController)
          else
            LocalSearchBuilder.new(CatalogController)
          end
      end

      def set_local_filter_param_to_default
        return if local_filter_param_present?
        params[:local_filter] = local_filter_default.to_s
      end

      def local_filter_applied?
        if params.key?(:local_filter)
          params[:local_filter].to_s == 'true'
        elsif current_search_session_has_local_filter?
          current_search_session.try(:query_params).fetch('local_filter').to_s == 'true'
        else
          local_filter_default.to_s == 'true'
        end
      end

      def current_search_session_has_local_filter?
        current_search_session.present? &&
          current_search_session.try(:query_params) &&
          current_search_session.try(:query_params).key?('local_filter')
      end

      def local_filter_param_present?
        local_filter_whitelist.include?(params[:local_filter])
      end

      def local_filter_whitelist
        %w[true false]
      end

      def local_filter_default
        TrlnArgon::Engine.configuration.apply_local_filter_by_default
      end
    end
  end
end
