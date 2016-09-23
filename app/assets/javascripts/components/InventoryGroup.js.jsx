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
    
    this.setState({foodItems: foodItems, currentQuantity: this.getCurrentQuantity(), unitPrice: this.getUnitPrice()})
  },
  getUnitPrice: function() {
    let totalUnitPrice, quantity
    totalUnitPrice = quantity = 0

    $.map(this.state.foodItems, function(foodItem, index) {
      quantity += foodItem.current_quantity
      totalUnitPrice += foodItem.current_quantity * foodItem.unit_price
    })

    return totalUnitPrice / quantity
  },
  getCurrentQuantity: function() {
    let currentQuantity = 0
    $.map(this.state.foodItems, function(foodItem, index) {
      currentQuantity += foodItem.current_quantity
    })
    return currentQuantity
  },
  toggleItems: function() {
    this.setState({
      showItems: !this.state.showItems
    })
  },
  render: function() {
    const { name } = this.props
    const { currentQuantity, quantityOrdered, unitPrice, foodItems } = this.state

    return (
      <tbody>
        <tr className='sub-header' onClick={this.toggleItems}>
           <td className="text-left">{name}</td>
           <td className="text-left"></td>
           <td className="text-left"></td>
           <td>{currentQuantity}</td>
           <td>{quantityOrdered}</td>
           <td></td>
           <td><Currency value={unitPrice}/></td>
           <td></td>
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