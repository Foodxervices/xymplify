const ActiveLink = function(links) {
  $(links).click(function() {
    $(links).removeClass('active')
    $(this).addClass('active')
  })
}