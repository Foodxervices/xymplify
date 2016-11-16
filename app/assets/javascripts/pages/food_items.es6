Foodxervices.food_items = {
  index: {
    init: () => {
      Utils.initConfirmation()
    }
  },
  form: {
    init: () => {
      $('#auto-populate').click(function() {
        let code = $('#food_item_code').val()

        if(code) {
          $.get({
            url: $(this).attr('ref') + `?code=${code}`
          })
        }

        return false
      })
    }
  }
}