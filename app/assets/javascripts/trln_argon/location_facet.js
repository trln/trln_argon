Blacklight.onLoad(function() {

  	$(window).load(function(){

      if ($("body").hasClass("local-filter")) {

        // get values from rails (_facets.html.erb)
        var argonHSL = $('#location-data').data('argon-hsl');
        var argonLAW = $('#location-data').data('argon-law');
        var argonInstitution = $('#location-data').data('argon-institution');

        // hide first two facets
        $('.facet_select:contains("' + argonHSL + '")').parent().addClass("hidden");
        $('.facet_select:contains("' + argonLAW + '")').parent().addClass("hidden");

        // open local institution and expand
        $('.facet_select:contains("' + argonInstitution + '")').parent().addClass("twiddle-open");
        $('.facet_select:contains("' + argonInstitution + '")').parent().children("ul").css("display", "block");

        // hide results after 10
        $('ul.facet-hierarchy > .twiddle-open > ul > li:gt(9)').hide();

        // add 'more' and 'less' button at end
        $('ul.facet-hierarchy > .twiddle-open > ul').append( "<div><a class='more_locations_link'>more <span class='sr-only'>Locations</span> »</a></div>" );
        $('ul.facet-hierarchy > .twiddle-open > ul').append( "<div><a class='less_locations_link' style='display: none;'>less <span class='sr-only'>Locations</span> »</a></div>" );

        // click 'more' to show all
        $('.more_locations_link').click(function() {
            $('ul.facet-hierarchy .twiddle-open > ul > li:gt(9)').show();
            $('.more_locations_link').hide();
            $('.less_locations_link').show();
        });

        // click 'less' to hide
        $('.less_locations_link').click(function() {
            $('ul.facet-hierarchy .twiddle-open > ul > li:gt(9)').hide();
            $('.more_locations_link').show();
            $('.less_locations_link').hide();
        });

      }

  	});

});
