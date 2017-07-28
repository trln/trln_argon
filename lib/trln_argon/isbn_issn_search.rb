module TrlnArgon
  module IsbnIssnSearch
    extend ActiveSupport::Concern

    included do
      if respond_to?(:before_action)
        prepend_before_action :strip_extraneous_chars_from_isbn_issn_search, only: :index
      end
    end

    private

    def strip_extraneous_chars_from_isbn_issn_search
      isbn_issn_param.gsub!(/[^Xx0-9]/, '') if isbn_issn_param
    end

    def isbn_issn_param
      if params[:search_field] == 'isbn_issn' && params[:q]
        params[:q]
      elsif params[:search_field] == 'advanced' && params[:isbn_issn]
        params[:isbn_issn]
      end
    end
  end
end
