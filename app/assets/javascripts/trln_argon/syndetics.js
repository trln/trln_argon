Blacklight.onLoad(function() {

  // Get natural width of thumbnails and hide empty syndetics thumbs

  	$(window).load(function(){

      $('#documents div.thumbnail').find('img').each(function () {
  			var $this = $(this), width = $(this).get(0).naturalWidth;
        var $parentdiv = $(this).closest('div');
        if (width < 2) {
          $parentdiv.addClass('hidden');
        } else {
          $parentdiv.addClass('valid-thumbnail');
        }
  		});

      $('#document div.thumbnail').find('img').each(function () {
  			var $this = $(this), width = $(this).get(0).naturalWidth;
        var $parentdiv = $(this).closest('div');
        if (width < 2) {
          $parentdiv.addClass('hidden');
        } else {
          $parentdiv.addClass('valid-thumbnail');
        }
  		});

  	});


});
