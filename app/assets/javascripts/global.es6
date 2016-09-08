const Foodxervices = {
  init: function() {
    Utils.initFileInput()
  }
}

$( document ).ajaxComplete(function() {
  Utils.initFileInput()
})