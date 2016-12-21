Foodxervices.carts = {
  info: {
    init: () => {
      $('.table-order:not(.init-date)').each(function() {
        $(this).addClass('init-date')
        let tableOrder = $(this)
        let orderId = tableOrder.attr('rel')
        let kitchenId = tableOrder.data('kitchen-id')
        // Date
        let dateInput = tableOrder.find('input[name=request_for_delivery_date]').first()
        let delivery_days = $(dateInput).data('days')

        let days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday']
        let disable_days = []

        $.each(days, function(index, day) {
          if($.inArray(day, delivery_days) == -1) {
            disable_days.push(index)
          }
        })
        
        $(dateInput).datepicker({
          daysOfWeekDisabled: disable_days,
          startDate: '+1d',
          enableOnReadonly: true,
          format: 'dd/mm/yyyy'
        })

        $(dateInput).keypress(function (evt) {
          return false
        });

        // Time
        let timeInput = tableOrder.find('input[name=request_for_delivery_time]')
        timeInput.timepicker({ defaultTime: false })

        $(dateInput).add(timeInput).change(function() {
          if(dateInput.val() != '' && timeInput.val() != '') {
            $.ajax({
              type: 'POST',
              url: `/kitchens/${kitchenId}/carts/${orderId}/update_request_for_delivery_at`,
              data: { request_for_delivery_at: `${dateInput.val()} ${timeInput.val()}` }
            });
          }
        });
      })

      
    }
  }
}