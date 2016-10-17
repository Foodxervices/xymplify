const InventoryGroup = React.createClass({
  getInitialState: function() {
    return {
      currentQuantity: 0,
      quantityOrdered: 0,
      unitPrice: 0,
      showItems: true,
      foodItems: this.props.foodItems,
    }
  },
  componentDidMount: function() {
    this.setState({
      currentQuantity: this.getCurrentQuantity(),
      quantityOrdered: this.getQuantityOrdered(),
      unitPrice: this.getUnitPrice()
    })
  },
  updateCurrentQuantity: function(foodItemId, current_quantity) {
    let foodItems = []

    $.map(this.state.foodItems, function(foodItem, index) {
      if(foodItem.id == foodItemId) {
        foodItem.current_quantity = current_quantity
      }

      foodItems.push(foodItem)
    })
    
    this.setState({foodItems: foodItems, currentQuantity: this.getCurrentQuantity(), quantityOrdered: this.getQuantityOrdered(), unitPrice: this.getUnitPrice()})
  },
  getUnitPrice: function() {
    let totalPrice, quantity, currentQuantity
    totalPrice = quantity = 0

    $.map(this.state.foodItems, function(foodItem, index) {
      currentQuantity = formatNumber(foodItem.current_quantity)
      quantity += currentQuantity
      totalPrice += currentQuantity * foodItem.default_unit_price
    })

    return totalPrice / quantity
  },
  getCurrentQuantity: function() {
    let currentQuantity = 0
    $.map(this.state.foodItems, function(foodItem, index) {
      currentQuantity += formatNumber(foodItem.current_quantity)
    })
    return currentQuantity
  },
  getQuantityOrdered: function() {
    let quantityOrdered = 0
    $.map(this.state.foodItems, function(foodItem, index) {
      quantityOrdered += formatNumber(foodItem.quantity_ordered)
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
    const { currentQuantity, quantityOrdered, unitPrice, foodItems } = this.state

    return (
      <tbody>
        <tr className='sub-header' onClick={this.toggleItems}>
           <td className="text-left">{name}</td>
           <td className="text-left"></td>
           <td className="text-left"></td>
           <td>{formatNumber(currentQuantity)}</td>
           <td>{formatNumber(quantityOrdered)}</td>
           <td></td>
           <td><Currency value={unitPrice} symbol={restaurant_currency_symbol}/></td>
        </tr>
        {
          this.state.showItems &&
          $(foodItems).map((index, foodItem) => {
            return <InventoryItem key={foodItem.id} {...foodItem} onCurrentQuantityChange={this.updateCurrentQuantity} />
          })
        }
      </tbody>
    );
  }
});