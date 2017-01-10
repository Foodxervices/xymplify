const InventoryGroup = React.createClass({
  getInitialState: function() {
    return {
      currentQuantity: 0,
      quantityOrdered: 0,
      unitPrice: 0,
      showItems: true,
      inventories: this.props.inventories,
    }
  },
  componentDidMount: function() {
    this.setState({
      currentQuantity: this.getCurrentQuantity(),
      quantityOrdered: this.getQuantityOrdered(),
      unitPrice: this.getUnitPrice()
    })
  },
  updateCurrentQuantity: function(inventoryId, current_quantity) {
    let inventories = []

    $.map(this.state.inventories, function(inventory, index) {
      if(inventory.id == inventoryId) {
        inventory.current_quantity = current_quantity
      }

      inventories.push(inventory)
    })
    
    this.setState({inventories: inventories, currentQuantity: this.getCurrentQuantity(), quantityOrdered: this.getQuantityOrdered(), unitPrice: this.getUnitPrice()})
  },
  getUnitPrice: function() {
    let totalPrice, quantity, currentQuantity
    totalPrice = quantity = 0

    $.map(this.state.inventories, function(inventory, index) {
      currentQuantity = formatNumber(inventory.current_quantity)
      quantity += currentQuantity
      totalPrice += currentQuantity * inventory.default_unit_price
    })

    return totalPrice / quantity
  },
  getCurrentQuantity: function() {
    let currentQuantity = 0
    $.map(this.state.inventories, function(inventory, index) {
      currentQuantity += formatNumber(inventory.current_quantity)
    })
    return currentQuantity
  },
  getQuantityOrdered: function() {
    let quantityOrdered = 0
    $.map(this.state.inventories, function(inventory, index) {
      quantityOrdered += formatNumber(inventory.quantity_ordered)
    })
    return quantityOrdered
  },
  toggleItems: function() {
    this.setState({
      showItems: !this.state.showItems
    })
  },
  render: function() {
    const { name, restaurant_currency_symbol } = this.props
    const { currentQuantity, quantityOrdered, unitPrice, inventories } = this.state
    
    return (
      <tbody>
        <tr className='sub-header' onClick={this.toggleItems}>
           <td className="text-left">{name}</td>
           <td className="text-left"></td>
           <td className="text-left"></td>
           <td>{formatNumber(currentQuantity)}</td>
           <td></td>
           <td>{formatNumber(quantityOrdered)}</td>
           <td></td>
           <td><Currency value={unitPrice} symbol={restaurant_currency_symbol}/></td>
        </tr>
        {
          this.state.showItems &&
          $(inventories).map((index, inventory) => {
            return <InventoryItem key={inventory.id} {...inventory} onCurrentQuantityChange={this.updateCurrentQuantity} />
          })
        }
      </tbody>
    );
  }
});