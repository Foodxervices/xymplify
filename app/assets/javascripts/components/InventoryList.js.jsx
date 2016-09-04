const InventoryList = React.createClass({
  render: function() {
    const { groups } = this.props

    return (
      <table className="table table-striped text-center">
        <thead>
          <tr>
             <th>Item Name</th>
             <th>Supplier</th>
             <th className="text-center">Current Quantity</th>
             <th className="text-center">Quantity Ordered</th>
             <th className="text-center">Unit</th>
             <th className="text-center">Price per Unit</th>
          </tr>
        </thead>
        {$.map(groups, function(foodItems, name){
          return <InventoryGroup key={name} name={name} foodItems={foodItems}/>
        })}
      </table>
    );
  }
});