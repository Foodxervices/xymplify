Foodxervices.carts = {
  form: {
    init: () => {
      let default_kitchen_id = $('#food_item_filter_kitchen_ids').selectpicker('val')

      $('#kitchen_id').selectpicker('val', default_kitchen_id)

      filter()

      function filter() {
        let kitchen_id = $('#kitchen_id').selectpicker('val')
        if(kitchen_id == '') {
          $('.cart-item').show()
        }
        else {
          $(`.cart-item:not(.kitchen${kitchen_id})`).hide() 
          $(`.kitchen${kitchen_id}`).show() 
        }
      }

      $('#kitchen_id').change(function() {
        filter()
      })
    }
  }
}