const InventoryList = React.createClass({
  render: function() {
    const { groups, restaurant_currency_symbol } = this.props

    return (
      <table className="table table-striped text-center">
        <thead>
          <tr>
             <th className="text-left">Item Name</th>
             <th className="text-left">Supplier</th>
             <th className="text-center">Category</th>
             <th width="150">Current Quantity</th>
             <th width="100"></th>
             <th>Qt. Ordered</th>
             <th>Unit</th>
             <th>Price per Unit</th>
          </tr>
        </thead>
        {$.map(groups, function(inventories, name){
          return <InventoryGroup key={name} name={name} inventories={inventories} restaurant_currency_symbol={restaurant_currency_symbol}/>
        })}
      </table>
    );
  }
});