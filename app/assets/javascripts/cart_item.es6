const CartItem = function(item) {
  this.submitting = false
  this.item = $(item)
  this.foodItemId = this.item.data('id')
  this.restaurantId = this.item.data('restaurant-id')
  this.quantityInput = this.item.find('.quantity-input').first()
  this.addToCartBtn = this.item.find('.btn-add').first()

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
  if(this.submitting) {
    return 
  }

  this.submitting = true
  $.post({
    url: `/restaurants/${this.restaurantId}/carts/add.js`,
    data: { 
      food_item_id: this.foodItemId,
      quantity: this.quantity()
    },
    success: () => {
      this.quantityInput.val(0)
      this.submitting = false
    }
  });
}
