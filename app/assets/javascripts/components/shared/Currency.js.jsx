const Currency = React.createClass({
  render: function() {
    const {value, symbol} = this.props
    return <span value={value}>{Utils.formatPrice(value, symbol)}</span>
  }
});