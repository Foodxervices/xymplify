Foodxervices.categories = {
  index: {
    init: function() {
      Foodxervices.categories.shared.init();
    }
  },
  by_supplier: {
    init: function() {
      Foodxervices.categories.shared.init();
    }
  },
  frequently_ordered: {
    init: function() {
      Foodxervices.categories.shared.init();
    }
  },
  shared: {
    init: function() {
      Foodxervices.categories.shared.initOrderDetailsPosition();
      Foodxervices.categories.shared.initCartItem();
      Foodxervices.categories.shared.initAddAllBtn();
    },
    initOrderDetailsPosition: function() {
      $('#cart-details').width($('#cart-details-ref').width())

      $( window ).resize(function() {
        $('#cart-details').width($('#cart-details-ref').width())        
      })
    },
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
