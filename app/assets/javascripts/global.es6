const Foodxervices = {
  init: function() {
    Utils.init()
    new Sidebar('#sidebar')
  }
}

$( document ).ajaxStart(function() {
  $('body').addClass('submitting')
})

$( document ).ajaxComplete(function() {
  Utils.init()
  $('body').removeClass('submitting')
})

$( document ).ready(function() {
  Utils.paddingMain()
})

$( window ).resize(function() {
  Utils.paddingMain()
})