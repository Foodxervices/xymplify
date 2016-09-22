const Utils = {
  initConfirmation: () => {
    $('[data-toggle="confirmation"]:not(.delete)').confirmation()

    $('[data-toggle="confirmation"].delete').confirmation({
      onConfirm: function() {
        $(this).attr('data-method', 'delete')
      }
    })
  },
  initFileInput: () => {
    $('input[type=file]:not(.initialized)').each(function() {
      let extensions = $(this).attr('data-allowed-file-extensions')
      
      if(extensions) {
        extensions = `["${extensions.replace(/,/g, '","')}"]`
      }

      $(this).attr('data-allowed-file-extensions', extensions)
      $(this).addClass('initialized').fileinput()
    })
  },
  initSelectPicker: () => {
    const selects = $("form.simple_form select, .selectpicker").not('.jselect').removeAttr('required').removeAttr('aria-required').addClass('jselect')
    
    selects.each(function(index, select) {
      $(select).data('live-search', !$(this).hasClass('not-autocomplete') && $(this).find('option').length > 5).selectpicker({hideDisabled: true})
    })
  },
  formatPrice: (price, symbol='$',decimal=2) => {
    if(isNaN(price)) {
      price = 0 
    }
    return symbol + Number(price).toLocaleString(undefined, { minimumFractionDigits: decimal })
  }
}