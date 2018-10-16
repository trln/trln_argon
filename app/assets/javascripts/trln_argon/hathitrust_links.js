Blacklight.onLoad(function() {
  var oclc_numbers = [];
  $(".hathi-trust-link").each(function() {
    oclc_numbers.push ($(this).data("oclc-number"));
  });
  if (oclc_numbers.length !== 0) {
    oclc_numbers = oclc_numbers.join('|');
    $.get( "/hathitrust/" + oclc_numbers, function(data) {
      $.each(data, function(key, value) {
        if (value) {
          var hathitrust_div = $('.hathi-trust-link.' + key);
          hathitrust_div.html(value);
        }
      });
    });
  }
});
