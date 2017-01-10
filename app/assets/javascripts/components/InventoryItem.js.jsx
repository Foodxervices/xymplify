const InventoryItem = React.createClass({
  getInitialState: function() {
    return {
      showSubmit: false
    }
  },
  minusQuantity: function() {
    this.updateCurrentQuantity(parseFloat(this.props.current_quantity) - 1)
  },
  plusQuantity: function() {
    this.updateCurrentQuantity(parseFloat(this.props.current_quantity) + 1)
  },
  updateCurrentQuantity: function(nextCurrentQuantity) {
    let nextQuantity = parseFloat(nextCurrentQuantity) || 0

    if(nextQuantity !== formatNumber(nextQuantity)) {
      nextCurrentQuantity = formatNumber(nextQuantity)
    }

    if(nextQuantity >= 0) {
      this.props.onCurrentQuantityChange(this.props.id, nextCurrentQuantity)  
      this.setState({ showSubmit: true })
    }
  },
  submit: function() {
    $.ajax({
      type: 'PATCH',
      url: `/restaurants/${this.props.restaurant_id}/inventories/${this.props.id}`,
      data: { inventory: { current_quantity: this.props.current_quantity } },
      success: (data) => {
        if(!data.success) {
          const { id, current_quantity } = data.inventory
          this.props.onCurrentQuantityChange(id, current_quantity)
        }
        this.setState({ showSubmit: false })
      }
    });
  },
  render: function() {
    const { name, supplier_name, category_name, current_quantity, quantity_ordered, unit, unit_price, symbol, can_update, tag_list } = this.props
  
    return (
      <tr className="item">
         <td></td>
         <td className="text-left">{supplier_name}</td>
         <td className="text-center">{category_name}</td>
         <td className="current-quantity">
            { (can_update &&
              <div className="form-inline">
                <a className="btn btn-minus form-control" onClick={this.minusQuantity}>-</a> 
                <input ref='currentQuantity' className="form-control" type="number" value={current_quantity} onChange={(event) => this.updateCurrentQuantity(event.target.value)}/>
                <a className="btn btn-plus form-control" onClick={this.plusQuantity}>+</a> 
              </div>) ||
              current_quantity
            }
         </td>
         <td>{ this.state.showSubmit ? <a className="btn btn-primary" onClick={this.submit}>Submit</a> : '' }</td>
         <td className="quantity-ordered">{formatNumber(quantity_ordered)}</td>
         <td className="unit-text">{unit}</td>
         <td className="unit-price"><Currency value={unit_price} symbol={symbol}/></td>
      </tr>
    );
  }
});