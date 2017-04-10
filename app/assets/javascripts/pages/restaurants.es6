Foodxervices.restaurants = {
  dashboard: {
    init: function() {
      $('.alert-listing').each(function() {
        new AlertListing($(this))
      })

      $('#graph-links a').first().click()
    }
  },
  show: {
    init: function() {
      new TableFilter('kitchen_filter_keyword')
    }
  }
}