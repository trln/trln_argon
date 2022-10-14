module TrlnArgon
  module ViewHelpers
    module RenderConstraintsHelperBehavior
      # include BlacklightAdvancedSearch::RenderConstraintsOverride

      # handles a special case only in TRLN
      def render_constraints_query(my_params = params)
        if my_params[:doc_ids].nil?
          super(my_params)
        else
          label = t('trln_argon.bookmarks.constraint_label')
          value = truncate_doc_ids(my_params)
          render_constraint_element(
            label, value,
            remove: search_action_path(remove_doc_ids(my_params).except(:controller, :action))
          )
        end
      end

      def truncate_doc_ids(my_params = params)
        my_params[:doc_ids].gsub('|', ', ').truncate(45, separator: ',')
      end

      def remove_doc_ids(my_params = params)
        my_params = Blacklight::SearchState.new(my_params, blacklight_config).to_h
        my_params.delete(:doc_ids)
        my_params
      end
    end
  end
end
