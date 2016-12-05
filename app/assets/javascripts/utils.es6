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
      let uploadUrl = $(this).attr('data-upload-url') || null

      if(extensions) {
        extensions = `["${extensions.replace(/,/g, '","')}"]`
      }

      $(this).attr('data-allowed-file-extensions', extensions)

      $(this).addClass('initialized').fileinput({ removeFromPreviewOnError: true, showUpload: showUpload, initialPreviewAsData: true, uploadUrl: uploadUrl })
    })
  },
  initSelectPicker: () => {
    const selects = $("form.simple_form select, .selectpicker").not('.jselect').removeAttr('required').removeAttr('aria-required').addClass('jselect')
    
    selects.each(function(index, select) {
      $(select).data('live-search', !$(this).hasClass('not-autocomplete') && $(this).find('option').length > 5).selectpicker({hideDisabled: true})
    })
  },
  initTaggable:() => {
    $('input.taggable:not(.taggable-initialized)').each(function() {
      $(this).addClass('taggable-initialized')

      $(this).tokenfield({
        autocomplete: {
          source: $(this).data('source'),
          delay: 100,
          beautify: true
        },
        showAutocompleteOnFocus: true
      })

      $(this).on('tokenfield:createtoken', function (event) {
        var existingTokens = $(this).tokenfield('getTokens');
        $.each(existingTokens, function(index, token) {
            if (token.value === event.attrs.value)
              event.preventDefault();
        });
      });
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
    $('#sidebar').css('padding-top', $('#menu').outerHeight())
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
  }
}