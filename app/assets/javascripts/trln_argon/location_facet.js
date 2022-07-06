Blacklight.onLoad(function() {

    $(window).on('load', function(){

      if ($("body").hasClass("blacklight-catalog-index")) {

        // get values from rails (_facets.html.erb)
        var argonHSL = $('#location-data').data('argon-hsl');
        var argonLAW = $('#location-data').data('argon-law');
        var argonInstitution = $('#location-data').data('argon-institution');
        var locationFacetLimit = $('#location-data').data('location-facet-limit');
        var facetLocationWrapper = $('#facet-location_hierarchy_f');

        // hide first two facets
        facetLocationWrapper.find('.facet_select:contains("' + argonHSL + '")').parent().addClass("d-none");
        facetLocationWrapper.find('.facet_select:contains("' + argonLAW + '")').parent().addClass("d-none");

        // open local institution and expand
        facetLocationWrapper.find('.facet_select:contains("' + argonInstitution + '")').parent().addClass("twiddle-open");
        facetLocationWrapper.find('.facet_select:contains("' + argonInstitution + '")').parent().children("ul").css("display", "block");

        // if there are more than 10 results
        if ( facetLocationWrapper.find('ul.facet-hierarchy > .twiddle-open > ul > li').length > parseInt(locationFacetLimit) ) {

          // hide results after 10
          facetLocationWrapper.find('ul.facet-hierarchy > .twiddle-open > ul > li').slice( parseInt(locationFacetLimit) ).hide();

          // add 'more' and 'less' button at end
          facetLocationWrapper.find('ul.facet-hierarchy > .twiddle-open > ul').append( "<li role='treeitem' class='location-more-toggle-wrapper'><a class='more_locations_link'>more <span class='sr-only'>Locations</span> »</a><a class='less_locations_link' style='display: none;'>less <span class='sr-only'>Locations</span> »</a></li>" );

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

    // general facet 'onclick' handler; needs some work AJC TODO
    $('li.twiddle').on('click', function(t) {
      if ( t.target == this ) {
        $(this).toggleClass("twiddle-open");
        $(this).children("ul").slideToggle();
      }
    });
});
