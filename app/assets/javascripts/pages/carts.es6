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
        
        dateInput.datepicker({
          daysOfWeekDisabled: [1,2,3],
          startDate: new Date(dateInput.data('start-date')),
          enableOnReadonly: true,
          format: 'dd/mm/yyyy'
        })

        // Time
        let timeInput = tableOrder.find('input[name=request_for_delivery_time]')
        timeInput.timepicker({ defaultTime: false })

        $(timeInput).on('hide.timepicker', function(e) {
          post(dateInput, timeInput, kitchenId, orderId)
        })
        $(dateInput).on('hide', function(e) {
          post(dateInput, timeInput, kitchenId, orderId)
        });
      }) 

      function post(dateInput, timeInput, kitchenId, orderId) {
        if(dateInput.val() != '' && timeInput.val() != '') {
          $.ajax({
            type: 'POST',
            url: `/kitchens/${kitchenId}/carts/${orderId}/update_request_for_delivery_at`,
            data: { request_for_delivery_at: `${dateInput.val()} ${timeInput.val()}` },
            success: (data) => {
              if(!data.success) {
                alert(data.message)
              }
            }
          });
        }
      }
    }
  }
}