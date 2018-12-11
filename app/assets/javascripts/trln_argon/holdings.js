Blacklight.onLoad(function() {
// no longer needed!

  // iife to expand the items for a given location if we have been
  // linked directly to it.
  // (function() {
  //   var pageTarget = window.location.hash;
  //   if ( pageTarget ) {
  //     var locationRe = /^#item-container-/;
  //     if ( locationRe.test(pageTarget) ) {
  //       $("a[href*='" + pageTarget+ "']").click();
  //       $(pageTarget).animate({
  //           scrollTop: $(pageTarget).offset().top
  //         }, 500);
  //     }
  //   }
  // })();
});
