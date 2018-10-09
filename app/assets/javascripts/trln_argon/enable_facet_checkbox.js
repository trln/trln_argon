Blacklight.onLoad(function() {

  $(window).load(function(){

    var numCheckboxes = $('.facet-checkbox-wrapper').length;

    if (numCheckboxes) {

      $( '.facet-checkbox-wrapper' ).each( function( index, element ) {

          facet_field = $( this ).data("facet-field");
          checkbox_field = $( this ).data("checkbox-field");

          if (facet_field != undefined) {

            $(".blacklight-" + facet_field + " .panel-heading").hide();

            var facetChecked = false;
            var theParam = "f%5B" + facet_field + "%5D%5B%5D=" + checkbox_field;

            // check if url param exists, add checked status
            if (window.location.href.indexOf(theParam) > -1) {
              $("#checkbox_" + facet_field).attr("checked", "checked");
              $(".blacklight-" + facet_field).addClass("checkbox-facet");
              $(".blacklight-" + facet_field).addClass("facet_limit-active checkbox-facet-checked");
              facetChecked = true;
            } else {
              $("#checkbox_" + facet_field).removeAttr("checked", "checked");
              $(".blacklight-" + facet_field).addClass("checkbox-facet");
              $(".blacklight-" + facet_field).removeClass("facet_limit-active checkbox-facet-checked");
            }

            $("#checkbox_" + facet_field).click( function() {

              var theOGURL = window.location.href.toString();

              if (facetChecked == true) { // already checked

                if (window.location.href.indexOf("?" + theParam + "&") > -1) {
                  theParam = "?" + theParam;
                  var theNewURL = theOGURL.replace(theParam, "?");

                } else if (window.location.href.indexOf("?" + theParam) > -1) {
                  theParam = "?" + theParam;
                  var theNewURL = theOGURL.replace(theParam, "");

                } else {
                  theParam = "&" + theParam;
                  var theNewURL = theOGURL.replace(theParam, "");
                }

                window.location.href = theNewURL;

              } else {

                if (window.location.href.indexOf("?") > -1) {
                  var theNewURL = theOGURL + "&" + theParam;

                } else {
                  var theNewURL = theOGURL + "?" + theParam;
                }

                window.location.href = theNewURL;

              } // END already checked

            }); // click function

          } // END facet_field defined

      }); // END .facet-checkbox-wrapper loop

    } // END numCheckboxes

  }); // END window.load

}); // END Blacklight.onLoad
