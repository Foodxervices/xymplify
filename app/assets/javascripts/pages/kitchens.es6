Foodxervices.kitchens = {
  dashboard: {
    init: function() {
      $('.alert-listing').each(function() {
        new AlertListing($(this))  
      })

      $('#graph-links a').first().click()
    }
  }
}