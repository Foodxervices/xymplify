function formatNumber(num) {
  return Math.round(num * 100) / 100
}

const Utils = {
  init: () => {
    Utils.initFileInput()
    Utils.initConfirmation()
    Utils.initSelectPicker()
    Utils.initTaggable()
    Utils.disableSubmittingForm()
    Utils.initInputNumber()
    Utils.initDatePicker()
    Utils.paddingMain()
    Utils.initMentionsInput()
    Utils.initDateRange()
    Utils.initDragFileTip()
    Utils.initDatatable()
    Utils.initScrollbar()
  },
  initConfirmation: () => {
    $('[data-toggle="confirmation"]').each(function() {
      let method = $(this).data('link-method') || 'get'

      if($(this).hasClass('delete')) {
        method = 'delete'
      }


      $(this).confirmation({
        onConfirm: function() {
          $(this).attr('data-method', method)
        }
      })
    })
  },
  initFileInput: () => {
    $('input[type=file]:not(.initialized)').each(function() {
      let extensions = $(this).attr('data-allowed-file-extensions')
      let showUpload = $(this).attr('data-show-upload') || false
      let showPreview = $(this).attr('data-show-preview') || true

      if(extensions) {
        extensions = `["${extensions.replace(/,/g, '","')}"]`
      }

      $(this).attr('data-allowed-file-extensions', extensions)

      $(this).addClass('initialized').fileinput({ removeFromPreviewOnError: true, showUpload: showUpload, initialPreviewAsData: true, showPreview: showPreview })
    })
  },
  initDatatable:() => {
    $('.datatable:not(.dataTable)').DataTable({
      bFilter: false,
      bDestroy: true,
      initComplete: function(settings, json) {
        Utils.initSelectPicker()
      },
      columnDefs: [{
        "targets": 'no-sort',
        "orderable": false
      }]
    })
  },
  initScrollbar:() => {
    $('.nice-scroll').niceScroll();
  },
  initDragFileTip:() => {
    let body = $('body')[0]
    let timeOutId = null
    body.addEventListener("dragover", function(e) {
      $('input[type=file]').each(function() {
        if($(this).attr('multiple') != 'multiple') {
          clearTimeout(timeOutId)
          let btn = $(this).closest('.btn-file')
          let btnText = btn.find('.hidden-xs')
          if(btnText.attr('default-text') === undefined) {
            btnText.attr('default-text', btnText.text())
          }
          btn.addClass('drag-here')
          btnText.text('DROP ME HERE')

          timeOutId = setTimeout(function() {
            btn.removeClass('drag-here')
            btnText.text(btnText.attr('default-text'))
          }, 500)
        }
      })
    })
  },
  initSelectPicker: () => {
    const selects = $("form.simple_form select, .selectpicker, .dataTables_length select").not('.jselect').removeAttr('required').removeAttr('aria-required').addClass('jselect')

    selects.each(function(index, select) {
      $(select).data('live-search', !$(this).hasClass('not-autocomplete') && $(this).find('option').length > 5).selectpicker({hideDisabled: true})
    })
  },
  initTaggable:() => {
    $('input.taggable:not(.taggable-initialized)').each(function() {
      let input = $(this)

      input.addClass('taggable-initialized')
      let source = $(this).data('source') || ''

      input.tokenfield({
        autocomplete: {
          source: source.split(","),
          delay: 100,
          beautify: true
        },
        showAutocompleteOnFocus: true
      })

      input.on('tokenfield:createtoken', function (event) {
        var existingTokens = $(this).tokenfield('getTokens');
        $.each(existingTokens, function(index, token) {
            if (token.value === event.attrs.value)
              event.preventDefault();
        });
      });

      input.siblings('.token-input').blur(function() {
        input.tokenfield('createToken', $(this).val())
        $(this).val('')
      })

      if(input.attr('type') == 'email') {
        input.on('tokenfield:createdtoken', function (e) {
          var re = /\S+@\S+\.\S+/
          var valid = re.test(e.attrs.value)
          if (!valid) {
            $(e.relatedTarget).remove()
          }
        })
      }
    })
  },
  initDatePicker:() => {
    $('input.date_picker').datepicker()
  },
  initInputNumber:() => {
    $('input[type=number]:not(.jnumber)').change(function() {
      $(this).addClass('jnumber')
      $(this).val(formatNumber($(this).val()))
    })
  },
  formatPrice: (price, symbol='$',decimal=2) => {
    if(isNaN(price)) {
      price = 0
    }
    return symbol + Number(price).toLocaleString(undefined, { minimumFractionDigits: decimal })
  },
  disableSubmittingForm: () => {
    $('form').not('.jsubmitting').addClass('jsubmitting').submit(function() {
      if($('body').hasClass('submitting')) {
        return false
      }

      $('body').addClass('submitting')
    })
  },
  paddingMain: () => {
    $('main').css('top', $('#menu').outerHeight())
  },
  initMentionsInput: () => {
    $('.mention-input').each(function() {
      let content = $(this).val()

      $(this).mentionsInput({
        onDataRequest:function (mode, query, callback) {
          var data = $(this).data('collection')

          data = _.filter(data, function(item) { return item.name.toLowerCase().indexOf(query.toLowerCase()) > -1 });

          callback.call(this, data);
        }
      });

      $(this).val(content)
    })
  },
  initDateRange: function() {
    $('.date-range-picker').daterangepicker({
      "locale": { format: 'DD/MM/YYYY' },
      "ranges": {
        'Today': [moment(), moment()],
        'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
        'This Month': [moment().startOf('month'), moment().endOf('month')],
        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
      },
      "alwaysShowCalendars": true
    }, function(start, end, label) {
      console.log("New date range selected: ' + start.format('YYYY-MM-DD') + ' to ' + end.format('YYYY-MM-DD') + ' (predefined range: ' + label + ')");
    });
  }
}