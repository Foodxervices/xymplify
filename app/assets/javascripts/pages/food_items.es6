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

      new MultiUpload('#food_item_files', '#attachment_ids')

      Utils.initSelectPicker()
      $('#food_item_kitchen_ids').change(function() {
        if($(this).selectpicker('val').length > 1) {
          $('.form-group.food_item_files').first().hide()
        }
        else {
          $('.form-group.food_item_files').first().show()
        }
      })
    }
  }
}