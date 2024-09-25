import Blacklight from 'blacklight';

Blacklight.onLoad(function() {
  var phys_media_facet = $('.facet_limit.blacklight-physical_media_f');
  var phys_media_facet_active = $('.facet_limit.blacklight-resource_type_f.facet_limit-active');
  var res_type_facet_active = $('.facet_limit.blacklight-physical_media_f.facet_limit-active');

  // Physical Media facet is hidden unless:
  // Resource Type Facet is applied OR Physical Media facet is applied.
  if (phys_media_facet_active.length || res_type_facet_active.length) {
    phys_media_facet.show();
  } else {
    phys_media_facet.hide();
  }
});
