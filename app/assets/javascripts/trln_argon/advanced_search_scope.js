Blacklight.onLoad(function() {
  $(window).on('load', function(){

    // remove default mast search to fix duplicate IDs
    $(".blacklight-catalog-advanced_search #search-navbar").remove();
    $(".blacklight-trln-advanced_search #search-navbar").remove();

    // remove the skip link that leads to that mast search field
    $(".blacklight-catalog-advanced_search #skip-link a[href='#search_field']").remove();
    $(".blacklight-trln-advanced_search #skip-link a[href='#search_field']").remove();

    // change adv search scope
  	$(".blacklight-trln-advanced_search").length > 0 ? $('#option_trln').attr('checked',true) : $('#option_catalog').attr('checked',true);

  	$("input[type='radio'][name='option']").change(function() {
        var action = $(this).val();
        $(".advanced").attr("action", "/" + action);
     });
  });
});
