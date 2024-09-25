import Blacklight from 'blacklight';

Blacklight.onLoad(function() {
  // Fetch Internet Archive IDs from the DOM
  // for Internet Archive linking
  var internet_archive_ids = [];
  $(".internet-archive-link").each(function() {
    internet_archive_ids.push ($(this).data("internet-archive-id"));
  });

  // Fetch OCLC Numbers from the DOM
  // for Hathitrust linking
  var oclc_numbers = [];
  $(".hathi-trust-link").each(function() {
    oclc_numbers.push ($(this).data("oclc-number"));
  });

  // Check the internet_archive route for
  // any Internet Archive links to render.
  // See InternetArchiveControllerBehavior.
  if (internet_archive_ids.length !== 0) {
    internet_archive_ids = internet_archive_ids.join('||')
    var internet_archive_response = $.ajax({
      url: "/internet_archive/" + internet_archive_ids,
      timeout: 10000
    });
  } else {
    var internet_archive_response = [];
  }

  // Check the hathitrust route for
  // any Hathitrust links to render.
  // See HathitrustControllerBehavior.
  if (oclc_numbers.length !== 0) {
    oclc_numbers = oclc_numbers.join('|');
    var hathitrust_response = $.ajax({
      url: "/hathitrust/" + oclc_numbers,
      timeout: 10000
    });
  } else {
    var hathitrust_response = [];
  }

  // When both the internet_archive and hathitrust responses are in hand
  // first add all the internet_archive links. Then add all the hathitrust
  // links. If there is an internet_archive link then the hathitrust link
  // will NOT be added if both are available for the same record.
  $.when(internet_archive_response, hathitrust_response).then(function(ia_data, ht_data) {
    if (ia_data.length !== 0) {
      $.each(ia_data[0], function(key, value) {
        if (value) {
          var internet_archive_div = $('.internet-archive-link.' + key);
          internet_archive_div.html(value);
          internet_archive_div.prev('.hathi-trust-link').remove();
        }
      });
    }

    if (ht_data.length !== 0) {
      $.each(ht_data[0], function(key, value) {
        if (value) {
          $('.hathi-trust-link.' + key).html(value);
        }
      });
    }
  });

});
