const Sidebar = function(sidebar) {
  this.sidebar = $(sidebar)
  this.sidebar.prepend('<i/>')
  this.toggleButton = this.sidebar.find('> i')
  this.collapse()

  this.toggleButton.click(() => {
    this.toggle()
  })

  $(document).click((event) => { 
    if(!$(event.target).closest(this.sidebar).length) {
      this.collapse()
    }        
  })
}

Sidebar.prototype.collapse = function() {
  this.sidebar.removeClass("expanded").addClass("collapsed");
  this.state = 'collapsed'
}

Sidebar.prototype.expand = function() {
  this.sidebar.removeClass("collapsed").addClass("expanded");
  this.state = 'expanded'
}

Sidebar.prototype.toggle = function() {
  if(this.state == 'collapsed') {
    this.expand()
  }
  else {
    this.collapse()
  }
}
