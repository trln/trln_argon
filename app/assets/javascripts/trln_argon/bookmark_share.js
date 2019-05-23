// override default bookmark sharing link behavior and instead open modal with copyable link text

$(document).on('click', '#share_bookmarksLink', function( e ){
  
  e.preventDefault();
  
  var bookmarkShareText= $('#share_bookmarksLink').text(); //Share
  var bookmarkNameText= $('#content h2.page-heading').text(); //Bookmarks
  var shareBookmarksText = bookmarkShareText + " " + bookmarkNameText;
  var shareBookmarksHelperText = "Use this link to " + bookmarkShareText.toLowerCase() + " your " + bookmarkNameText.toLowerCase();
  var bookmarkShareURL = window.location.origin + $('#share_bookmarksLink').attr('href');


  // create modal
  $('#content').append('<div class="modal fade" id="bookmark-modal" tabindex="-1" role="dialog"><div class="modal-dialog" role="document"><div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button><h4 class="modal-title">' + shareBookmarksText + '</h4></div><div class="modal-body"><p class="help-block">' + shareBookmarksHelperText + '</p><div class="input-group"><input id="sharing-url-holder" type="text" class="form-control" data-autoselect="" value="' + bookmarkShareURL + '" aria-label="' + shareBookmarksText + '" readonly=""><span class="input-group-btn"><button id="copy-to-clipboard" class="btn btn-default" type="button" data-toggle="tooltip" data-placement="bottom" title="Copy to clipboard"><i class="fa fa-clipboard" aria-hidden="true"></i></button></span></div></div><div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">Close</button></div></div></div></div>'); 

  // open modal
  $('#bookmark-modal').modal('show');

  // initiate tooltip
  $('#copy-to-clipboard').tooltip();

  // copy URL
  $('#copy-to-clipboard').click(function() {

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

  });

});