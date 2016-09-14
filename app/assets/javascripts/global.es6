const Foodxervices = {
  init: function() {
    Utils.initFileInput()
    Utils.initConfirmation()
    new Sidebar('#sidebar')
  }
}

$( document ).ajaxComplete(function() {
  Utils.initFileInput()
})