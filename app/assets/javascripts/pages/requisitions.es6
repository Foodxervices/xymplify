Foodxervices.requisitions = {
  index: {
    init: () => {
      $('.grid').masonry({
        itemSelector: '.grid-item',
        percentPosition: true
      });
    }
  },
  form: {
    init: () => {
      Foodxervices.requisitions.form.initSupplierSelect()

      $(document).on('nested:fieldAdded', function(event) {
        Foodxervices.requisitions.form.initSupplierSelect()
      })
    },
    initSupplierSelect: () => {
      $('.requisition_items_supplier_id:not(.supplier-select) select').addClass('supplier-select').change(function() {
        let foodItem = $(this).closest('tr').find('.requisition_items_food_item_id select')
        foodItem.find('optgroup').attr('disabled',true)
        foodItem.find("optgroup[label='"+$(this).find("option:selected").text()+"']").attr('disabled',false)
        foodItem.selectpicker('refresh');
      })
    }
  }
}