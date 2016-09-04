const InventoryItem = function(inventoryItem) {
  this.object = inventoryItem
  this.id = this.object.data('id')
  this.currentQuantity = inventoryItem.find('.current-quantity input').first()
  this.quantityOrdered = inventoryItem.find('.quantity-ordered').first()
  this.btnPlus  = inventoryItem.find('.btn-plus').first()
  this.btnMinus = inventoryItem.find('.btn-minus').first()

  this.btnPlus.click(() => {
    this.plusCurrentQuantity()
  })

  this.btnMinus.click(() => {
    this.minusCurrentQuantity()
  })

  this.currentQuantity.change(() => {
    this.submitCurrentQuantity()
  })
}

InventoryItem.prototype.getCurrentQuantity = function() {
  return parseInt(this.currentQuantity.val())
}

InventoryItem.prototype.getQuantityOrdered = function() {
  return parseInt(this.quantityOrdered.text())
}

InventoryItem.prototype.plusCurrentQuantity = function() {
  this.currentQuantity.val(this.getCurrentQuantity() + 1).change()
}

InventoryItem.prototype.minusCurrentQuantity = function() {
  this.currentQuantity.val(this.getCurrentQuantity() - 1).change()
}

InventoryItem.prototype.submitCurrentQuantity = function() {
  $.ajax({
    type: 'PATCH',
    url: `/inventories/${this.id}/update_current_quantity`,
    data: { food_item: { current_quantity: this.getCurrentQuantity() } },
    success: (food_item) => {
      this.currentQuantity.val(food_item.current_quantity)
    }
  });
}