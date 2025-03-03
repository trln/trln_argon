Blacklight.onLoad(function () {
  /**
   * Ensures that checkbox-only facets (currently, access_type which is either
   * online or not)
   * (a) do not display a header and
   * (b) automatically select/deselect based on whether the value of the checkbox
   * changes.
   */
  $(window).on('load', function () {

    $('#facets ul.blacklight-facet-checkboxes').each(function () {

      var wrapper = $(this);

      // hide the header
      wrapper.closest('div.card').find('.facet-field-heading').hide();
      var fieldName = wrapper.closest('.facet-content').attr('id').replace('facet-', '');

      wrapper.find('li').each(function () {
        var listItem = $(this);
        var fieldValue = listItem.find('input').val();
        var field = listItem.find(":checkbox");
        var parameter = "f_inclusive[" + fieldName + "][]";

        var currentURL = new URL(window.location);
        var currentParams = currentURL.searchParams;

        // Check the checkbox if it exists in the URL
        if (currentParams.has(parameter) && currentParams.getAll(parameter).includes(fieldValue)) {
          field.prop("checked", true);
        } else {
          field.prop("checked", false);
        }

        // Add change listener to reload the page when checkbox is checked/unchecked
        field.on('change', function () {
          if (field.is(':checked')) {
            currentParams.append(parameter, fieldValue);
          } else {
            currentParams.delete(parameter);
          }
          currentURL.search = currentParams.toString();
          window.location.assign(currentURL.toString());
        });
      });
    });
  });
}); // END Blacklight.onLoad
