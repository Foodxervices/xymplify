const Foodxervices = {
  init: function() {
    this.startTurbolinks()
  },
  startTurbolinks: () => {
    if(!Turbolinks.supported) { return; }
    Turbolinks.controller.adapter.progressBar.setValue(0);
    Turbolinks.controller.adapter.progressBar.show();
  }
}
