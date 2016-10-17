function formatNumber(num) {
  return Math.round(num * 100) / 100
}

const InventoryList = React.createClass({
  render: function() {
    const { groups, restaurant_currency_symbol } = this.props

    return (
      <table className="table table-striped text-center">
        <thead>
          <tr>
             <th className="text-left">Item Name</th>
             <th className="text-left">Supplier</th>
             <th className="text-left">Kitchen</th>
             <th>Current Quantity</th>
             <th>Quantity Ordered</th>
             <th>Unit</th>
             <th>Price per Unit</th>
          </tr>
        </thead>
        {$.map(groups, function(foodItems, name){
          return <InventoryGroup key={name} name={name} foodItems={foodItems} restaurant_currency_symbol={restaurant_currency_symbol}/>
        })}
      </table>
    );
  }
});