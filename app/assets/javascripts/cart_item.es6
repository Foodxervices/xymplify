const CartItem = function(item) {
  this.item = $(item)
  this.foodItemId = this.item.data('id')
  this.restaurantId = this.item.data('restaurant-id')
  this.quantityInput = this.item.find('.quantity-input').first()
  this.addToCartBtn = this.item.find('.btn-add').first()

  this.addToCartBtn.click(() => {
    if(this.quantity() == 0) {
      return false
    }
    
    this.submit()
    return false
  })
}

CartItem.prototype.quantity = function() {
  return parseInt(this.quantityInput.val())
}

CartItem.prototype.submit = function() {
  $.post({
    url: `/restaurants/${this.restaurantId}/carts/add.js`,
    data: { 
      food_item_id: this.foodItemId,
      quantity: this.quantity()
    },
    success: () => {
      this.quantityInput.val(0)
    }
  });
}
