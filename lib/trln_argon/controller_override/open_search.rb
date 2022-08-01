module TrlnArgon
  module ControllerOverride
    module OpenSearch
      extend ActiveSupport::Concern

      # Blacklight override
      # Ability to configure when to respond to OpenSearch requests
      # set ALLOW_OPEN_SEARCH to 'false' to disable OpenSearch
      #    default is 'true'
      # set OPEN_SEARCH_Q_MIN_LENGTH to set the minimum query length
      #    that will trigger an OpenSearch. Default is 4.
      def opensearch
        respond_to do |format|
          format.xml do
            render layout: false
          end
          format.json do
            render json: open_search_data
          end
        end
      end

      private

      def open_search_data
        if TrlnArgon::Engine.configuration.allow_open_search == 'false'
          { msg: 'The OpenSearch API has been disabled.' }
        else
          q = params[:q] || ''
          if q.length < TrlnArgon::Engine.configuration.open_search_q_min_length.to_i
            []
          else
            search_service.opensearch_response
          end
        end
      end
    end
  end
end
