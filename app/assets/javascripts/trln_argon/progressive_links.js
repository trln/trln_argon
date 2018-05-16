Blacklight.onLoad(function() {
    $('a.progressive-link').hover(function (){
        $(this).prevAll().addBack().css("text-decoration", "underline");
    },function(){
        $(this).prevAll().addBack().css("text-decoration", "none");
    });
});
