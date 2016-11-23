Foodxervices.food_items = {
  index: {
    init: () => {
      Utils.initConfirmation()
    }
  },
  form: {
    init: () => {
      $('#auto-populate:not(.initialized)').addClass('initialized').click(function() {
        let code = $('#food_item_code').val()

        if(code) {
          $.get({
            url: $(this).attr('ref') + `?code=${code}`
          })
        }

        return false
      })

      new MultiUpload('#food_item_files', '#food_item_attachment_ids')
    }
  }
}