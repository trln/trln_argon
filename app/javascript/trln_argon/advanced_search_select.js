import Blacklight from 'blacklight';

Blacklight.onLoad(function() {
    $('.advanced-search-facet-select').chosen({
        allow_single_deselect: true,
        no_results_text: 'No results matched'
    });

   resizeChosen();
   jQuery(window).on('resize', resizeChosen);
});

function resizeChosen() {
   $(".chosen-container").each(function() {
       $(this).attr('style', 'width: 100%');
   });
}
