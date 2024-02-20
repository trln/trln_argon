# frozen_string_literal: true

module TrlnArgon
  class LocationFacetItemPresenter < Blacklight::FacetItemPresenter
    # See https://github.com/projectblacklight/blacklight/blob/release-7.x/app/presenters/blacklight/facet_item_presenter.rb

    ##
    # Get the displayable version of a facet's value
    #
    # @return [String]
    def label
      TrlnArgon::LookupManager.instance.map([value.split(':').first, 'facet', value.split(':').last].join('.')) || value
    end
  end
end
