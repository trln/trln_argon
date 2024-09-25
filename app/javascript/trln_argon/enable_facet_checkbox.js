import Blacklight from 'blacklight';

Blacklight.onLoad(function() {
  /**
   * Ensures that checkbox-only facets (currently, access_type which is either
   * online or not)
   * (a) do not display a header and
   * (b) automatically select/deselect based on whether the value of the checkbox
   * changes.
   */
  $(window).on('load', function() {
    $('#facet-panel-collapse .facet-checkbox-wrapper').each(
      function(index, element) {
        var wrapper = $(this);

        // hide the header
        wrapper.closest('div.card').find('.facet-field-heading').hide();

        var fieldName = wrapper.data('facetField');
        if ( !fieldName ) {
          return;
        }
        var fieldValue = wrapper.data('checkboxField');
        var field = wrapper.find(":checkbox");
        var parameter = "f[" + fieldName + "][]";
        var currentURL = new URL(window.location);
        var currentParams = currentURL.searchParams;
        if ( currentParams.has(parameter) ) {
          field.attr("checked", "checked");
        } else {
          field.removeAttr("checked");
        }
        field.on('change', () => {
          if ( field.is(':checked')) {
            currentParams.set(parameter, fieldValue);
            currentURL.searchParams = currentParams;
            window.location.searchParams = currentParams;
          } else {
            currentParams.delete(parameter);
            currentURL.searchParams = currentParams;
          }
          console.log("sending to ", currentURL);
          window.location.assign(currentURL.toString());
        });
      });
  });
}); // END Blacklight.onLoad
