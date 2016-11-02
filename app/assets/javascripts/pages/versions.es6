Foodxervices.versions = {
  index: {
    init: function() {
      this.item_type   = $('#version_filter_item_type')
      this.attributes  = $('#version_filter_attributes') 
      this.event       = $('#version_filter_event')
      this.initSearch()
      this.initDateRange()
    },
    initSearch: function() {
      let { item_type, event } = this
      
      this.itemTypeTrigger()

      item_type.change(() => {
        this.itemTypeTrigger()
        attributes.selectpicker('val', '')
      })
      
      this.updateEvenTrigger()

      event.on('change', (e, clickedIndex, newValue, oldValue) => {
        this.updateEvenTrigger()
      })
    },
    updateEvenTrigger: function() {
      let { event, attributes } = this 

      if(event.val() == 'update') {
        attributes.selectpicker('show');
      } 
      else {
        attributes.selectpicker('val', null);
        attributes.selectpicker('hide');
      }
    },
    itemTypeTrigger: function() {
      let { item_type, attributes } = this

      let class_name = item_type.find("option:selected").text();

      attributes.find("optgroup").not("[label='"+class_name+"']").attr('disabled',true)
      attributes.find("optgroup[label='"+class_name+"']").attr('disabled',false)
      attributes.selectpicker('refresh');
    },
    initDateRange: function() {
      $('#version_filter_date_range').daterangepicker({
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
}