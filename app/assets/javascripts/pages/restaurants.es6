Foodxervices.restaurants = {
  dashboard: {
    init: function() {
      $('.alert-listing').each(function() {
        new AlertListing($(this))  
      })
      
      setTimeout(() => {
        CostGraph.init()  
      }, 200)
    }
  }
}