const Utils = {
  initConfirmation: () => {
    $('[data-toggle="confirmation"]:not(.delete)').confirmation()

    $('[data-toggle="confirmation"].delete').confirmation({
      onConfirm: function() {
        $(this).attr('data-method', 'delete')
      }
    })
  }
}