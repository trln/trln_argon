Blacklight.onLoad(function () {

  // Get natural width of thumbnails and hide empty syndetics thumbs

  var selectors = ['#document div.thumbnail', '#documents div.thumbnail'];
  function processElement(el, imgWidth) {
    var imgClass = imgWidth < 2 ? 'd-none' : 'valid-thumbnail';
    el.addClass(imgClass);
  }

  $(window).on('load', function () {
    for( var i = 0; i < selectors.length; i++ ) {
      $(selectors[i]).find('img').each(function () {
        var $this = $(this), width = $(this).get(0).naturalWidth;
        var $parentdiv = $(this).closest('div');
        processElement($parentdiv, width);
      });
    }
  });
});
