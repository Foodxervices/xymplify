Foodxervices.dishes = {
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
      Foodxervices.dishes.form.initConverter()
      
      $(document).on('nested:fieldAdded', function(event) {
        Foodxervices.dishes.form.initConverter()
      })

      $('.dish_items_food_item_id select').trigger('change')
    },
    initConverter: () => {
      $('.dish_items_food_item_id select:not(".converter")').addClass('converter').change(function() {
        let row = $(this).closest('tr')
        let unitSelect = row.find('.dish_items_unit select').first()
        let rateInput = row.find('.dish_items_unit_rate input').first()

        if(!$(this).val()) {
          return false
        }
        
        $.ajax({
          method: "GET",
          url: `/food_items/${$(this).val()}/conversions`,
          success: (data) => {
            unitSelect.empty()
            $.each(data.conversions, function(index, conversion) {
              unitSelect.append($("<option></option>")
                .attr({
                  value: conversion.unit,
                  rate: conversion.rate
                }).text(conversion.unit));
            });
            unitSelect.val(unitSelect.data('value'))
            unitSelect.selectpicker('refresh')

            rateInput.val(unitSelect.find(':selected').attr('rate'))
          }
        })
      })

      $('.dish_items_unit select:not(".converter")').addClass('converter').change(function() {
        let row = $(this).closest('tr')
        let rateInput = row.find('.dish_items_unit_rate input').first()
        rateInput.val($(this).find(':selected').attr('rate'))
      })
    }
  }
}