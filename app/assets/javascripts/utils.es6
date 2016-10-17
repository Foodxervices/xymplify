const Utils = {
  init: () => {
    Utils.initFileInput()
    Utils.initConfirmation()
    Utils.initSelectPicker()
    Utils.initTaggable()
    Utils.disableSubmittingForm()
    Utils.initInputNumber()
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

      if(extensions) {
        extensions = `["${extensions.replace(/,/g, '","')}"]`
      }

      $(this).attr('data-allowed-file-extensions', extensions)

      $(this).addClass('initialized').fileinput({ showUpload: showUpload })
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
  initInputNumber:() => {
    $('input[type=number]:not(.jnumber)').change(function() {
      $(this).addClass('jnumber')
      $(this).val(parseFloat($(this).val()).toFixed(2))
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
  }
}