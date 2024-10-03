// override default bookmark sharing link behavior and instead open modal with copyable link text

$(document).on('click', '#share_bookmarksLink', function( e ){

  e.preventDefault();

  var bookmarkShareText= $('#share_bookmarksLink').text(); //Share
  var bookmarkNameText= $('#content h1.page-heading').text(); //Bookmarks
  var shareBookmarksText = bookmarkShareText + " " + bookmarkNameText;
  var shareBookmarksHelperText = "Use this link to " + bookmarkShareText.toLowerCase() + " your " + bookmarkNameText.toLowerCase();
  var bookmarkShareURL = window.location.origin + $('#share_bookmarksLink').attr('href');


  // create modal
  $('#content').append('<div class="modal fade" id="bookmark-modal" tabindex="-1" role="dialog"><div class="modal-dialog" role="document"><div class="modal-content"><div class="modal-header"><h4 class="modal-title">' + shareBookmarksText + '</h4><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div><div class="modal-body"><p class="form-text">' + shareBookmarksHelperText + '</p><div class="input-group"><input id="sharing-url-holder" type="text" class="form-control" data-autoselect="" value="' + bookmarkShareURL + '" aria-label="' + shareBookmarksText + '" readonly=""><span class="input-group-btn"><button id="copy-to-clipboard" class="btn btn-outline-secondary" type="button" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Copy to clipboard"><i class="fa fa-clipboard" aria-hidden="true"></i></button></span></div></div><div class="modal-footer"><button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button></div></div></div></div>');

  // open modal
  $('#bookmark-modal').modal('show');

  // don't use toopltip for iOS
  if (!navigator.userAgent.match(/ipad|ipod|iphone/i)) {
    $('#copy-to-clipboard').tooltip();
  }

  // copy URL
  $('#copy-to-clipboard').click(function() {

    // separate approach for iOS
    if (navigator.userAgent.match(/ipad|ipod|iphone/i)) {
      $('#sharing-url-holder').attr('readonly', false);
      $('#sharing-url-holder').attr('contenteditable', true);
      range = document.createRange();
      range.selectNodeContents($('#sharing-url-holder')[0]);
      var s = window.getSelection();
      s.removeAllRanges();
      s.addRange(range);
      $('#sharing-url-holder')[0].setSelectionRange(0, $('#sharing-url-holder').val().length);
      document.execCommand('copy'); // only works with iOS 10+
      $('#sharing-url-holder').attr('readonly', true);
      $('#sharing-url-holder').attr('contenteditable', false);

    } else {

      $('#sharing-url-holder').focus();
      $('#sharing-url-holder').select();

      try {
        var successful = document.execCommand('copy');
        var msg = successful ? 'successful' : 'unsuccessful';
        $('#copy-to-clipboard').attr('title', 'Copied!').tooltip('fixTitle').tooltip('show');
        $('#bookmark-modal .tooltip').delay( 1000 ).fadeOut();
        $('#copy-to-clipboard').attr('title', 'Copy to clipboard').tooltip('fixTitle');
      } catch (err) {
        console.log('Oops, unable to copy');
      }

    }

  });

});
