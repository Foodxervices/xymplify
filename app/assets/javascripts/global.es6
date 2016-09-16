const Foodxervices = {
  init: function() {
    Utils.initFileInput()
    Utils.initConfirmation()
    Utils.initSelectPicker()
    new Sidebar('#sidebar')
  }
}

$( document ).ajaxComplete(function() {
  Utils.initFileInput()
  Utils.initSelectPicker()
})