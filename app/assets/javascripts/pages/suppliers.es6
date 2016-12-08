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
  }
}