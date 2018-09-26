Blacklight.onLoad(function() {

  function fetch_and_display_toggle_count(toggle_label) {
    if (toggle_label.length) {
      var query_path = toggle_label.first().data( "count-only-path" );
      var toggle_text = toggle_label.first().text();
      $.get( query_path, function( data ) {
        var toggle_text_with_count = toggle_text + " (" + data['response']['numFound'].toLocaleString() + ")";
        toggle_label.text(toggle_text_with_count);
      });
    }
  }

  fetch_and_display_toggle_count($('.blacklight-catalog-index .toggle-trln label'));
  fetch_and_display_toggle_count($('.blacklight-trln-index .toggle-local label'));
});
