const Currency = React.createClass({
  render: function() {
    const {value} = this.props
    return <span value={value}>{Utils.formatPrice(value)}</span>
  }
});