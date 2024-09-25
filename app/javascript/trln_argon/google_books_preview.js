import Blacklight from 'blacklight';

Blacklight.onLoad(function() {
    $(window).on('load', function() {
        var previewAvailable = function (item) {
            try {
                return $.inArray(item.accessInfo.viewability, ['PARTIAL', 'ALL_PAGES']) >= 0;
            } catch(e) {
            }
            return false;
        };

        var getPreviewLink = function(data) {
            if ( data.items && data.items.length > 0 ) {
                try {
                    for(var i=0, n=data.items.length; i<n; i++) {
                        var item = data.items[i];
                        if ( previewAvailable(item) ) {
                            return item.volumeInfo.previewLink;
                        }
                    }
                } catch(e) {
                    console.info("Unable to determine google books preview link", e);
                }
            }
            return false;
        };

      var isbn = $('#google-books').data('isbn');
      var logoUrl = $('#shared-application-data').data().googleBooksLogoUrl
      if (isbn) {
        for (i = 0; i < isbn.length; i++) {
            $.ajax({
                url:'https://www.googleapis.com/books/v1/volumes?q=isbn:' + isbn[i],
                success: function(data) {
                    var link = getPreviewLink(data);
                    if (! link ) {
                        return;
                    }
                    $('#google-books').each(function () {
                        if ($(this).find('img').length == 0) {
                            $('#google-books').append("<img id='google-books-preview-image' " +
                                "alt='Google Preview' " +
                                "src='" + logoUrl + "'>");
                            $("#google-books-preview-image").after(
                                '<a href=' + link +
                                ' target="_blank"> Preview this title via Google Book Search </a>');
                         }
                    });
                }
            });
         }
      }
  });
});
