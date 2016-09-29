const InventoryList = React.createClass({
  render: function() {
    const { groups } = this.props

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
             <th>Item Type</th>
          </tr>
        </thead>
        {$.map(groups, function(foodItems, name){
          return <InventoryGroup key={name} name={name} foodItems={foodItems}/>
        })}
      </table>
    );
  }
});