# frozen_string_literal: true

module Blacklight
  module Suggest
    extend ActiveSupport::Concern

    included do
      include Blacklight::Configurable
      include Blacklight::SearchHelper

      copy_blacklight_config_from(CatalogController)
    end

    def index
      respond
    end

    def show
      respond
    end

    def respond
      respond_to do |format|
        format.json do
          render json: category_suggestions(params[:category])
        end
      end
    end

    def category_suggestions(category = nil)
      case category
      when 'title'
        suggestions_service(category).title_suggestions
      when 'author'
        suggestions_service(category).author_suggestions
      when 'subject'
        suggestions_service(category).subject_suggestions
      else
        suggestions_service(category).suggestions
      end
    end

    def suggestions_service(category = nil)
      Blacklight::SuggestSearch.new(params, category, repository).suggestions
    end
  end
end
