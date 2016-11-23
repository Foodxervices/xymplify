const MultiUpload = function(fileInput, fileIdsHiddenInput) {
  this.fileInput = $(fileInput)

  if(this.fileInput.hasClass('multi-upload')) {
    return false
  }
  
  this.fileInput.addClass('multi-upload')
  this.fileIdsHiddenInput = $(fileIdsHiddenInput)
  this.initIds = this.fileIdsHiddenInput.val()

  Utils.initFileInput()

  this.fileInput.on("filebatchselected", function(event, files) {
    $(this).fileinput("upload");
  })

  this.fileInput.on('fileuploaded', (event, data, previewId, index) => {
    let response = data.response
    let file_ids = this.fileIdsHiddenInput.val()
    file_ids = file_ids.split(",");
    file_ids.push(response.id)

    this.fileIdsHiddenInput.val(file_ids.join(","))

    $('#'+previewId).find('.kv-file-remove').click(() => {
      let file_ids = this.fileIdsHiddenInput.val()
      file_ids = file_ids.split(",");
      file_ids = _.filter(file_ids, function(i) { return i != response.id })
      this.fileIdsHiddenInput.val(file_ids.join(","))
    })
  })

  this.fileInput.on('filecleared', (event) => {
    this.fileIdsHiddenInput.val(this.initIds)
  });
}