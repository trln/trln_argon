// test if an element is in the viewport
$.fn.isInViewport = function() {
  var elementTop = $(this).offset().top;
  var elementBottom = elementTop + $(this).outerHeight();
  var viewportTop = $(window).scrollTop();
  var viewportBottom = viewportTop + $(window).height();
  return elementBottom > viewportTop && elementTop < viewportBottom;
};

Blacklight.onLoad(function() {

  $("#documents .hider, #holdings .hider").click(function() {
    event.preventDefault();
    var theAnchorID = $(this).attr('href');
    if (!$(theAnchorID).isInViewport()) {
      $('html,body').animate({scrollTop: $(theAnchorID).offset().top - 150}, 'fast');
    }
  });

  $("#document .less").click(function() {
    event.preventDefault();
    var theAnchorID = $(this).find(".btn").attr('href');
    if (!$(theAnchorID).isInViewport()) {
      $('html,body').animate({scrollTop: $(theAnchorID).offset().top - 50}, 'fast');
    }
  });

  var lineHeight = function(element) {
    var pxHeight = window.getComputedStyle(element, null).getPropertyValue("line-height");
    return parseInt(pxHeight.replace(/px$/, ''), 10);
  }

  $(".expandable-content").each( function() {

    var me = $(this);
    var parent = me.parent();
    var origHeight = me.height();
    var contractedHeight = lineHeight(this) * 3 + 2;

    if ( origHeight <= contractedHeight ) {
      return;
    }

    var contract = function(evt) {
      me.addClass('contracted');
      if ( me.children(":first").is("ul") ) {
        me.addClass('contracted-ul');
      }
      parent.attr('aria-expanded', 'false');
    }

    var expand = function(evt) {
      me.removeClass('contracted');
      me.removeClass('contracted-ul');
      parent.attr('aria-expanded', 'true');
    };

    contract(); // if we got this far, we want to shrink

    parent.find('.more').click(function() {
      expand();
    });


    parent.find('.less').click(function() {
      contract();
    });

  });


});
