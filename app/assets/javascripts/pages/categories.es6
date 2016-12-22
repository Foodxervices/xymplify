Foodxervices.categories = {
  index: {
    init: function() {
      $('.cart-item').each(function() {
        new CartItem($(this))
      })
    }
  },
  by_supplier: {
    init: function() {
      $('.cart-item').each(function() {
        new CartItem($(this))
      })
    }
  },
  frequently_ordered: {
    init: function() {
      $('.cart-item').each(function() {
        new CartItem($(this))
      })
    }
  }
}
