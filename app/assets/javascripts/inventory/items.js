const InventoryItems = function(rel) {
  this.itemObjects = $(`.item[rel=${rel}]`)

  this.items = []
  this.currentQuantity = 0

  this.itemObjects.each((index, item) => {
    this.items.push(new InventoryItem($(item)))
  })
}

InventoryItems.prototype.show = function() {
  this.itemObjects.fadeIn()
}

InventoryItems.prototype.hide = function() {
  this.itemObjects.fadeOut()
}

InventoryItems.prototype.getCurrentQuantity = function() {
  let currentQuantity = 0

  this.items.forEach((item) => {
    currentQuantity += item.getCurrentQuantity()
  })

  return this.currentQuantity = currentQuantity
} 

InventoryItems.prototype.getQuantityOrdered = function() {
  let quantityOrdered = 0

  this.items.forEach((item) => {
    quantityOrdered += item.getQuantityOrdered()
  })

  return this.quantityOrdered = quantityOrdered
} 
