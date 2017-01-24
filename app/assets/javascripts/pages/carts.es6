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
          format: 'dd/mm/yyyy'
        })

        // Time
        let timeInput = tableOrder.find('input.time-picker')
        timeInput.timepicker({ defaultTime: false })

        $(timeInput).on('hide.timepicker', function(e) {
          let dateInput = $(this).closest('tr').find('.date-picker')
          post(dateInput, $(this), kitchenId, orderId, $(this).data('type'))
        })
        $(dateInput).on('hide', function(e) {
          let timeInput = $(this).closest('tr').find('.time-picker')
          post($(this), timeInput, kitchenId, orderId, $(this).data('type'))
        });
      })

      function post(dateInput, timeInput, kitchenId, orderId, type) {
        if(dateInput.val() != '' && timeInput.val() != '') {
          $.ajax({
            type: 'POST',
            url: `/kitchens/${kitchenId}/carts/${orderId}/update_request_for_delivery_${type}_at`,
            data: { time: `${dateInput.val()} ${timeInput.val()}` },
            success: (data) => {
              if(!data.success) {
                alert(data.message)
              }
              else {
                $(`.table-order[rel=${orderId}]`).each((i, tableOrder) => {
                  $(tableOrder).find('input.date-picker').each((index, input) => {
                    if($(input).data('type') == type || $(input).val() == '') {
                      $(input).val(dateInput.val())
                    }
                  })

                  $(tableOrder).find('input.time-picker').each((index, input) => {
                    if($(input).data('type') == type || $(input).val() == '') {
                      $(input).val(timeInput.val())
                    }
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