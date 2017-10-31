Blacklight.onLoad(function() {
  Blacklight.do_holdings_display_behavior();
});

(function($) {
  Blacklight.do_holdings_display_behavior = function() {
    $("tr.item").hide();
      // activate  item hide/show click handler
      $(".loc-narrow-banner").on('click', function() {
        var container = $(this).closest("tbody");
        var data = $(this).closest("tr").data();
        // hides/shows and returns visibility
        var visible = container.find("tr.item." + data.locbroad + "." + data.locnarrow).toggle().is(":visible");
        var spander =  visible ? "(- hide items)" : "(+ show items)";
        $(this).find(".expander").text(spander);
        });
  };
})(jQuery);
