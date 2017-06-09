const Sidebar = function(sidebar) {
  this.body = $('body')
  this.sidebar = $(sidebar)
  this.sidebar.find('li a').prepend('<i/>')

  $('body').addClass('notransition')

  if(Cookies.get('sidebar-status') == 'collapsed') {
    this.collapse()
  }
  else {
    this.expand()
  }

  setTimeout(function() {
    $('body').removeClass('notransition')
    $('#cart-details').width($('#cart-details-ref').width() + 15)
  }, 1000)
}

Sidebar.prototype.collapse = function() {
  this.body.addClass("sidebar-collapsed")
  Cookies.set('sidebar-status', 'collapsed');
}

Sidebar.prototype.expand = function() {
  this.body.removeClass("sidebar-collapsed")
  Cookies.set('sidebar-status', 'expanded');
}

Sidebar.prototype.toggle = function() {
  if(Cookies.get('sidebar-status') == 'collapsed') {
    this.expand()
  }
  else {
    this.collapse()
  }

  if($('#cart-details').length > 0) {
    setTimeout(function() {
      $('#cart-details').width($('#cart-details-ref').width() + 15)
    }, 1000)
  }
}
