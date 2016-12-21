Foodxervices.versions = {
  index: {
    init: function() {
      this.item_type   = $('#version_filter_item_type')
      this.attributes  = $('#version_filter_attributes') 
      this.event       = $('#version_filter_event')
      this.initSearch()
    },
    initSearch: function() {
      let { item_type, event, attributes } = this
      
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
    }
  }
}