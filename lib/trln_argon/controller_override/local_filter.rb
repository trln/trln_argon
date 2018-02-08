module TrlnArgon
  module ControllerOverride
    module LocalFilter
      extend ActiveSupport::Concern

      included do
        before_action :set_local_filter_param_to_default, only: %i[index show]
        before_action :filtered_results_total, only: :index
        helper_method :filter_scope_name
        helper_method :local_filter_applied?
      end

      def filter_scope_name
        if controller_name == 'bookmarks'
          t('trln_argon.scope_name.bookmarks')
        elsif local_filter_applied?
          t("trln_argon.institution.#{TrlnArgon::Engine.configuration.local_institution_code}.short_name")
        else
          t('trln_argon.consortium.short_name')
        end
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

      private

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
