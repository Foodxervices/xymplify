const InventorySubHeader = function(rel) {
  this.object = $(`.sub-header[rel=${rel}]`).first()
  this.currentQuantity = this.object.find('.current-quantity').first()
  this.quantityOrdered = this.object.find('.quantity-ordered').first()
}

InventorySubHeader.prototype.getCurrentQuantity = function() {
  return paseInt(this.currentQuantity.text())
}

InventorySubHeader.prototype.getQuantityOrdered = function() {
  return paseInt(this.quantityOrdered.text())
}

InventorySubHeader.prototype.setCurrentQuantity = function(value) {
  this.currentQuantity.text(value)
}

InventorySubHeader.prototype.setQuantityOrdered = function(value) {
  this.quantityOrdered.text(value)
}