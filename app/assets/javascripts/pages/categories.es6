Foodxervices.categories = {
  index: {
    init: function() {
      Foodxervices.categories.shared.initCartItem();
      Foodxervices.categories.shared.initAddAllBtn();
    }
  },
  by_supplier: {
    init: function() {
      Foodxervices.categories.shared.initCartItem();
      Foodxervices.categories.shared.initAddAllBtn();
    }
  },
  frequently_ordered: {
    init: function() {
      Foodxervices.categories.shared.initCartItem();
      Foodxervices.categories.shared.initAddAllBtn();
    }
  },
  shared: {
    initCartItem: function() {
      $('.cart-item').each(function() {
        new CartItem($(this)).initAddToCartBtn()
      })
    },
    initAddAllBtn: function() {
      $('#btn-add-all').click(function() {
        if($(this).hasClass('submitting')) {
          return false
        }

        $(this).addClass('submitting')

        $('.cart-item').each(function() {
          new CartItem($(this)).submit()  
        })

        setTimeout(() => { $(this).removeClass('submitting') }, 3000)

        return false;
      })
    }
  }
}
