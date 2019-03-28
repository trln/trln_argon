Blacklight.onLoad(function() {
  $(window).load(function(){
  	
  	window.location.href.indexOf('advanced_trln') != -1 ? $('#option_trln').attr('checked',true) : $('#option_catalog').attr('checked',true);
  	
  	$("input[type='radio'][name='option']").change(function() {
        var action = $(this).val();
        $(".advanced").attr("action", "/" + action);
     });
  });
});