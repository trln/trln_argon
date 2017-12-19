Blacklight.onLoad(function() {
    $('.show-subjects a').hover(function (){
        $(this).prevAll().addBack().css("text-decoration", "underline");
    },function(){
        $(this).prevAll().addBack().css("text-decoration", "none");
    });
});
