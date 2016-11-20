const AlertListing = function(object) {
  this.object = object
  this.last_seen_at = new Date(this.object.data('last-seen-at'))

  this.object.find('.alert').each((index, alert) => {
    let created_at = new Date($(alert).data('created-at'))
    
    if(this.last_seen_at <= created_at) {
      $(alert).addClass('not-seen')
    }
  })
}