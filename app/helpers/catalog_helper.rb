# frozen_string_literal: true

module CatalogHelper
  include TrlnArgon::ViewHelpers::CatalogHelperBehavior

  def worldcat_search_available?
    WorldcatQueryService.available?
  end
end
