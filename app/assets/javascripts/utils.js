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
  },
  initFileInput: () => {
    $('input[type=file]:not(.initialized)').each(function() {
      let extensions = $(this).attr('data-allowed-file-extensions')

      if(extensions) {
        extensions = `["${extensions.replace(',', '","')}"]`
      }

      $(this).attr('data-allowed-file-extensions', extensions)
      $(this).addClass('initialized').fileinput()
    })
  }
}