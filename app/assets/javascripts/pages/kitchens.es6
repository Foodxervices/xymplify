Foodxervices.kitchens = {
  dashboard: {
    init: function() {
      $('.alert-listing').each(function() {
        new AlertListing($(this))  
      })
      new ActiveLink('#graph-links a')
      $('#graph-links a').first().click()
    }
  }
}