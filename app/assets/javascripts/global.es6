const Foodxervices = {
  init: function() {
    Utils.initFileInput()
    Utils.initConfirmation()
  }
}

$( document ).ajaxComplete(function() {
  Utils.initFileInput()
})