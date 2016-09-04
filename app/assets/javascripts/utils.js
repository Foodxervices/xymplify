const Utils = {
  initConfirmation: () => {
    $('[data-toggle="confirmation"]:not(.delete)').confirmation()

    $('[data-toggle="confirmation"].delete').confirmation({
      onConfirm: function() {
        $(this).attr('data-method', 'delete')
      }
    })
  },
  formatPrice: (price,decimal=2) => {
    if(isNaN(price)) {
      price = 0 
    }
    return '$' + Number(price).toLocaleString(undefined, { minimumFractionDigits: decimal })
  }
}