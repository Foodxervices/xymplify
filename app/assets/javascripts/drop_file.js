$.fn.dropZone = function() {
  var mouseOverClass = "mouse-over";

  var dropZone = this[0];
  var $dropZone = $(dropZone);
  var ooleft = $dropZone.offset().left;
  var ooright = $dropZone.outerWidth() + ooleft;
  var ootop = $dropZone.offset().top;
  var oobottom = $dropZone.outerHeight() + ootop;
  var inputFile = $dropZone.find("input[type='file']");
  dropZone.addEventListener("dragleave", function() {
    this.classList.remove(mouseOverClass);
  });
  dropZone.addEventListener("dragover", function(e) {
    e.preventDefault();
    e.stopPropagation();
    this.classList.add(mouseOverClass);
    var x = e.pageX;
    var y = e.pageY;
    
    inputFile.offset({
      top: y - 15,
      left: x - 100
    });

  }, true);
  dropZone.addEventListener("drop", function(e) {
    this.classList.remove(mouseOverClass);
  }, true);
}