import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

export default class extends Controller {
  static values = {
    plugins: Array,
  };

  connect() {
    this.select = new TomSelect(this.element, {
      plugins: this.pluginsValue,
      // Default is 50, we want unlimited to display all options
      maxOptions: null,
      // Passing the `item` function to the `render` arg allows us to customize what the selected item looks like when it's
      // added to the list of selected items. In this case, we're just wrapping the value (coming from the data set) in a
      // div to remove the count that's displayed in the option list.
      render: {
        item: function (data, escape) {
          return `<div>${escape(data.value)}</div>`;
        },
      },
    });
  }

  disconnect() {
    this.select?.destroy();
  }
}