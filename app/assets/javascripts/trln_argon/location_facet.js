Blacklight.onLoad(function() {

    $(window).on('load', function(){

      if ($("body").hasClass("blacklight-catalog-index")) {

        // get values from rails (_facets.html.erb)
        var argonHSL = $('#location-data').data('argon-hsl');
        var argonLAW = $('#location-data').data('argon-law');
        var argonInstitution = $('#location-data').data('argon-institution');
        var locationFacetLimit = $('#location-data').data('location-facet-limit');
        var facetLocationWrapper = $('#facet-location_hierarchy_f');
        var topLocationFacetItems = facetLocationWrapper.find('ul.facet-hierarchy > li');

        // hide top-level HSL & Law facets
        topLocationFacetItems.find('.facet-select:contains("' + argonHSL + '")').closest('li').addClass("d-none");
        topLocationFacetItems.find('.facet-select:contains("' + argonLAW + '")').closest('li').addClass("d-none");

        // open top-level local institution and expand
        topLocationFacetItems.find('.facet-select:contains("' + argonInstitution + '")').first().closest('li').addClass("twiddle-open");
        topLocationFacetItems.find('.facet-select:contains("' + argonInstitution + '")').first().closest('li').children("ul.collapse").addClass("show");

        // if there are more than 10 results
        if ( facetLocationWrapper.find('ul.facet-hierarchy > .twiddle-open > ul > li').length > parseInt(locationFacetLimit) ) {

          // hide results after 10
          facetLocationWrapper.find('ul.facet-hierarchy > .twiddle-open > ul > li').slice( parseInt(locationFacetLimit) ).hide();

          // add 'more' and 'less' button at end
          facetLocationWrapper.find('ul.facet-hierarchy > .twiddle-open > ul').append( "<li role='treeitem' class='location-more-toggle-wrapper'><a class='more_locations_link'>more <span class='visually-hidden'>Locations</span> »</a><a class='less_locations_link' style='display: none;'>less <span class='visually-hidden'>Locations</span> »</a></li>" );

          // click 'more' to show all
          facetLocationWrapper.find('.more_locations_link').click(function() {
              facetLocationWrapper.find('ul.facet-hierarchy .twiddle-open > ul > li').slice( parseInt(locationFacetLimit) ).show();
              facetLocationWrapper.find('.more_locations_link' ).hide();
              facetLocationWrapper.find('.less_locations_link' ).show();
          });

          // click 'less' to hide
          facetLocationWrapper.find('.less_locations_link').click(function() {
              facetLocationWrapper.find('ul.facet-hierarchy .twiddle-open > ul > li' ).slice( parseInt(locationFacetLimit) ).hide();
              facetLocationWrapper.find('ul.facet-hierarchy .twiddle-open > ul > li.location-more-toggle-wrapper' ).show();
              facetLocationWrapper.find('.more_locations_link' ).show();
              facetLocationWrapper.find('.less_locations_link' ).hide();
          });

        }

      }

    });

});
