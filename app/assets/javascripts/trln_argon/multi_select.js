Blacklight.onLoad(function () {

  // Initialize TomSelect on all multi-select elements
  // See https://tom-select.js.org
  document.querySelectorAll('#advanced_search_facets .multi-select').forEach((el)=>{
    let settings = {
      // See https://tom-select.js.org/plugins/
      plugins: ['checkbox_options',
                'caret_position',
                'remove_button']
    };

    new TomSelect(el, settings);
  });

  // Observe the multi-select divs to patch a11y issues with the checkboxes
  // that get dynamically added to the DOM via the 'checkbox_options' plugin.
  // https://tom-select.js.org/plugins/checkbox-options/
  // https://github.com/orchidjs/tom-select/blob/master/src/plugins/checkbox_options/plugin.ts

  const tomselect_checkbox_observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      if (mutation.type === 'childList') {
        mutation.addedNodes.forEach(node => {
          if (node.nodeType === 1 && node.matches('div.option')) {
            const checkbox = node.querySelector('input[type="checkbox"]');
            if (checkbox) {
              checkbox.setAttribute('tabindex', '-1');
              checkbox.setAttribute('aria-hidden', 'true');
              checkbox.setAttribute('aria-disabled', 'true');
              checkbox.setAttribute('role', 'presentation');
              checkbox.setAttribute('aria-labelledby', node.id);
            }
          }
        });
      }
    });
  });

  document.querySelectorAll('#advanced_search_facets .facet-multi-select').forEach((el)=>{
    tomselect_checkbox_observer.observe(el, { childList: true, subtree: true });
  });
});
