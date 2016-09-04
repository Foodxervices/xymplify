Foodxervices.inventories = {
  index: {
    init: () => {
      $('tr.sub-header').each(function() {
        new InventoryGroup($(this).attr('rel'))
      })
    }
  }
}