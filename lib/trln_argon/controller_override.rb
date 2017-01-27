module TrlnArgon
  module ControllerOverride
    extend ActiveSupport::Concern

    included do

      self.send(:include, BlacklightAdvancedSearch::Controller)

      before_action :local_filter_session
      before_action :filtered_results_total, only: :index

      helper_method :local_filter_applied?

      # TRLN Argon CatalogController configurations
      configure_blacklight do |config|

        # TODO: Consider making some of this configurabl in trln_argon_config.yml
        config.search_builder_class = TrlnArgonSearchBuilder
        config.default_per_page = 20

        # default advanced config values
        config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
        config.advanced_search[:url_key] ||= 'advanced'
        config.advanced_search[:query_parser] ||= 'dismax'
        config.advanced_search[:form_solr_parameters] ||= {}

      end


      private

      def filtered_results_total
        @filtered_results_total = filtered_results_query_response['response']['numFound']
      end

      def filtered_results_query_response
        filtered_response = repository.search(local_filter_search_builder.append(*additional_processor_chain_methods).with(search_state.to_h))
      end

      # This is needed so that controllers that inherit from CatalogController
      # Will have any additional processor chain methods applied to the 
      # query that fetches the local filter count
      def additional_processor_chain_methods
        search_builder.processor_chain - local_filter_search_builder.processor_chain - excluded_processor_chain_methods
      end

      def excluded_processor_chain_methods
        [:apply_local_filter]
      end

      def local_filter_search_builder
        if local_filter_applied?
          @local_filter_search_builder ||= ConsortiumSearchBuilder.new(CatalogController)
        else
          @local_filter_search_builder ||= LocalSearchBuilder.new(CatalogController)
        end
      end

      def local_filter_session
        if local_filter_param_present?
          set_local_filter_session_from_param
        elsif local_filter_session_set?
          set_local_filter_param_from_session
        else
          set_local_filter_param_and_session_to_default
        end
      end

      def local_filter_param_present?
        local_filter_whitelist.include?(params[:local_filter])
      end

      def local_filter_session_set?
        local_filter_whitelist.include?(session[:local_filter])
      end

      def set_local_filter_session_from_param
        session[:local_filter] = params[:local_filter]
      end

      def set_local_filter_param_from_session
        params[:local_filter] = session[:local_filter]
      end

      def set_local_filter_param_and_session_to_default
        session[:local_filter] = local_filter_default
        params[:local_filter] = local_filter_default
      end

      def local_filter_whitelist
        ['true', 'false']
      end

      def local_filter_applied?
        session[:local_filter] == 'true'
      end

      def local_filter_default
        TrlnArgon::Engine.configuration.apply_local_filter_by_default
      end

    end

  end
end
