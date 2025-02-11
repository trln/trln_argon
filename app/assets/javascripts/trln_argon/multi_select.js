Blacklight.onLoad(function () {
  document.querySelectorAll('.multi-select').forEach((el)=>{
    let settings = {
      // See https://tom-select.js.org/plugins/
      plugins: ['checkbox_options',
                'caret_position',
                'remove_button']
    };
    new TomSelect(el, settings);
  });
});
