Blacklight.onLoad(function() {
    $('a.progressive-link').hover(function (){
        $(this).prevAll().addBack().addClass('progressive-link-hover');
    },function(){
        $(this).prevAll().addBack().removeClass('progressive-link-hover');
    });
});
