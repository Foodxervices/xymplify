const InventoryGroup = function(rel) {
  this.subHeader = new InventorySubHeader(rel)
  this.items = new InventoryItems(rel)
  this.itemStatus = 'visible'
  this.execItemState()
  this.loadCurrentQuantity()
  this.loadQuantityOrdered()

  this.subHeader.object.click(() => {
    this.toggleItems()
  })
}

InventoryGroup.prototype.toggleItems = function() {
  this.itemStatus = this.itemStatus == 'invisible' ? 'visible' : 'invisible'
  this.execItemState()
}

InventoryGroup.prototype.execItemState = function() {
  switch(this.itemStatus) {
    case 'visible':
      this.items.show()
      break
    case 'invisible':
      this.items.hide()
      break
  }
}

InventoryGroup.prototype.loadCurrentQuantity = function() {
  this.subHeader.setCurrentQuantity(this.items.getCurrentQuantity())
}

InventoryGroup.prototype.loadQuantityOrdered = function() {
  this.subHeader.setQuantityOrdered(this.items.getQuantityOrdered())
}