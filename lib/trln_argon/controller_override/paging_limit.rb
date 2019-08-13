module TrlnArgon
  module ControllerOverride
    module PagingLimit
      extend ActiveSupport::Concern

      def limit_results_paging
        limit_paging(params[:page],
                     TrlnArgon::Engine.configuration.paging_limit,
                     paging_message)
      end

      def limit_facet_paging
        limit_paging(params['facet.page'],
                     TrlnArgon::Engine.configuration.facet_paging_limit,
                     facet_paging_message)
      end

      private

      def limit_paging(page, limit, message)
        if show_paging_alert?(page, limit) && !request.xhr?
          flash[:alert] = message
        elsif show_paging_error?(page, limit)
          flash[:error] = message
          redirect_to root_path
        end
      end

      def show_paging_alert?(page, paging_limit)
        page && page.to_i == paging_limit.to_i
      end

      def show_paging_error?(page, paging_limit)
        page && page.to_i > paging_limit.to_i
      end

      def paging_message
        t('trln_argon.paging_limit.results',
          paging_limit: TrlnArgon::Engine.configuration.paging_limit)
      end

      def facet_paging_message
        t('trln_argon.paging_limit.facets',
          facet_paging_limit: TrlnArgon::Engine.configuration.facet_paging_limit)
      end
    end
  end
end
