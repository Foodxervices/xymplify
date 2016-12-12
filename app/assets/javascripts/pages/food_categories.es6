Foodxervices.food_categories = {
  index: {
    init: function() {
      $(".sortable").sortable({
          axis: 'y',
          connectWith: ".connectedSortable",
          update: function (event, ui) {
            let ids = $(this).sortable('toArray', { attribute: "rel" });
            
            $.ajax({
              method: "PATCH",
              url: `/food_categories/update_priority`,
              data: { ids: ids }
            })
          }
      }); 
    }
  }
}