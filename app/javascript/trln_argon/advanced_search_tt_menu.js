import Blacklight from 'blacklight';

Blacklight.onLoad(function() {
    if ($("#advanced_search").length){
        $('.tt-menu').css({"position":"relative"});
    };
});
