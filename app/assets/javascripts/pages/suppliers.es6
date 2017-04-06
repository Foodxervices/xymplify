Foodxervices.suppliers = {
  index: {
    init: function() {
      $(".sortable").sortable({
          axis: 'y',
          connectWith: ".connectedSortable",
          update: function (event, ui) {
            let ids = $(this).sortable('toArray', { attribute: "rel" });

            $.ajax({
              method: "PATCH",
              url: `/suppliers/update_priority`,
              data: { ids: ids }
            })
          }
      });
    }
  },
  form: {
    init: function() {
      $('#supplier_block_delivery_dates').datepicker({
        multidate: true,
        multidateSeparator: ", ",
        todayBtn: true,
        format: 'dd/mm/yyyy',
        clearBtn: true
      });
    }
  }
}