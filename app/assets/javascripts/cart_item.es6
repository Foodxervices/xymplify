const CartItem = function(item) {
  this.item = $(item)
  this.submitting = false
  
  this.foodItemId = this.item.data('id')
  this.restaurantId = this.item.data('restaurant-id')
  this.kitchenId = this.item.data('kitchen-id')
  this.quantityInput = this.item.find('.quantity-input').first()
  this.addToCartBtn = this.item.find('.btn-add').first()
}

CartItem.prototype.initAddToCartBtn = function() {
  if(this.item.hasClass('i-cart')) {
    return false
  }
  this.item.addClass('i-cart')

  this.addToCartBtn.confirmation({
    onConfirm: () => {
      this.submit()
      return false
    }
  })

  this.addToCartBtn.click((e) => {
    if(this.quantity() == 0) {
      this.addToCartBtn.confirmation('hide')
    }
  })
}

CartItem.prototype.quantity = function() {
  return parseFloat(this.quantityInput.val())
}

CartItem.prototype.submit = function() {
  if(this.submitting || this.quantity() == 0) {
    return 
  }

  this.submitting = true
  
  $.ajax({
    type: 'POST',
    async: false,
    url: `/kitchens/${this.kitchenId}/carts/add.js`,
    data: { 
      food_item_id: this.foodItemId,
      quantity: this.quantity()
    },
    success: () => {
      this.quantityInput.val(0)
      this.submitting = false
      this.addToCartBtn.confirmation('hide')
    }
  });
}
