const InventoryItem = React.createClass({
  minusQuantity: function() {
    this.updateCurrentQuantity(this.props.current_quantity - 1)
  },
  plusQuantity: function() {
    this.updateCurrentQuantity(this.props.current_quantity + 1)
  },
  updateCurrentQuantity: function(nextCurrentQuantity) {
    nextCurrentQuantity = parseInt(nextCurrentQuantity) || 0
    
    if(nextCurrentQuantity < 0) {
      nextCurrentQuantity = 0 
    }

    this.props.onCurrentQuantityChange(this.props.id, nextCurrentQuantity)

    if(this.updateCurrentQuantityTimeOut) {
      clearTimeout(this.updateCurrentQuantityTimeOut)
      this.updateCurrentQuantityTimeOut = null
    }

    this.updateCurrentQuantityTimeOut = setTimeout(() => {
      $.ajax({
        type: 'PATCH',
        url: `/restaurants/${this.props.restaurant_id}/inventories/${this.props.id}/update_current_quantity`,
        data: { food_item: { current_quantity: nextCurrentQuantity } },
        success: (data) => {
          if(!data.success) {
            const { id, current_quantity } = data.food_item
            this.props.onCurrentQuantityChange(id, current_quantity)
          }
        }
      });
    }, 500)  
  },
  render: function() {
    const { name, supplier_name, kitchen_name, current_quantity, quantity_ordered, unit, unit_price, symbol, can_update_current_quantity, tag_list } = this.props
  
    return (
      <tr className="item">
         <td></td>
         <td className="text-left">{supplier_name}</td>
         <td className="text-left">{kitchen_name}</td>
         <td className="current-quantity">
            { (can_update_current_quantity &&
              <div className="form-inline">
                <a className="btn btn-minus form-control" onClick={this.minusQuantity}>-</a> 
                <input ref='currentQuantity' className="form-control" type="number" value={current_quantity} onChange={(event) => this.updateCurrentQuantity(event.target.value)}/>
                <a className="btn btn-plus form-control" onClick={this.plusQuantity}>+</a> 
              </div>) ||
              current_quantity
            }
         </td>
         <td className="quantity-ordered">{quantity_ordered}</td>
         <td className="unit-text">{unit}</td>
         <td className="unit-price"><Currency value={unit_price} symbol={symbol}/></td>
      </tr>
    );
  }
});