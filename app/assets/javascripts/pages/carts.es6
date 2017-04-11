Foodxervices.carts = {
  info: {
    init: () => {
      $('.table-order:not(.init-date)').each(function() {
        $(this).addClass('init-date')
        let tableOrder = $(this)
        let orderId = tableOrder.attr('rel')
        let kitchenId = tableOrder.data('kitchen-id')
        // Date
        let dateInput = tableOrder.find('input.date-picker')
        let delivery_days = $(dateInput).data('days')
        let block_dates = $(dateInput).data('block-dates').split(', ')

        let days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday']
        let disable_days = []

        $.each(days, function(index, day) {
          if($.inArray(day, delivery_days) == -1) {
            disable_days.push(index)
          }
        })

        dateInput.datepicker({
          daysOfWeekDisabled: disable_days,
          startDate: new Date(dateInput.data('start-date')),
          enableOnReadonly: true,
          format: 'dd/mm/yyyy',
          datesDisabled: block_dates
        })

        // Time
        let timeInput = tableOrder.find('input.time-picker')
        timeInput.timepicker({ defaultTime: false, timeFormat: 'h:mm p' })

        $(timeInput).on('hide.timepicker', function(e) {
          post($(this).closest('table'), kitchenId, orderId)
        })
        $(dateInput).on('hide', function(e) {
          post($(this).closest('table'), kitchenId, orderId)
        });
      })

      function post(table, kitchenId, orderId) {
        let dateInput = table.find(`.date-picker`)
        let startInput = table.find(`.time-picker[data-type=start]`)
        let endInput   = table.find(`.time-picker[data-type=end]`)

        if(dateInput.val() != '') {
          $.ajax({
            type: 'POST',
            url: `/kitchens/${kitchenId}/carts/${orderId}/update_request_delivery_date`,
            data: { 
              date: dateInput.val(),
              start_time: startInput.val(),
              end_time: endInput.val() 
            },
            success: (data) => {
              if(!data.success) {
                alert(data.message)
              }
              else {
                $(`.table-order[rel=${orderId}]`).each((i, tableOrder) => {
                  $(tableOrder).find('input.date-picker').each((index, input) => {
                    $(input).val(dateInput.val())
                  })

                  $(tableOrder).find(`.time-picker[data-type=start]`).each((index, input) => {
                    $(input).val(startInput.val())
                  })

                  $(tableOrder).find(`.time-picker[data-type=end]`).each((index, input) => {
                    $(input).val(endInput.val())
                  })
                })
              }
            }
          });
        }
      }
    }
  }
}