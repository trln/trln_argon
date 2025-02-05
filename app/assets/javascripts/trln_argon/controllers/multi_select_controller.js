document.addEventListener("DOMContentLoaded", function () {
    if (window.Stimulus) {
      // Only register the controller if Stimulus is loaded
      const application = window.Stimulus.Application.start();
  
      application.register("multi-select", class extends Stimulus.Controller {
        static values = { plugins: Array };
  
        connect() {
          this.select = new TomSelect(this.element, {
            plugins: this.pluginsValue,
            render: {
              item: function (data, escape) {
                return `<div>${escape(data.text)}</div>`;
              },
            },
          });
        }
  
        disconnect() {
          this.select?.destroy();
        }
      });
    } else {
      console.error("Stimulus is not loaded yet.");
    }
  });
