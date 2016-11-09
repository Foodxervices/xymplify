function init_retina_images() {
  if (window.matchMedia("only screen and (min--moz-device-pixel-ratio: 1.3), only screen and (-o-min-device-pixel-ratio: 2.6/2), only screen and (-webkit-min-device-pixel-ratio: 1.3), only screen  and (min-device-pixel-ratio: 1.3), only screen and (min-resolution: 1.3dppx)")) {
    return $.each($('img[data-at2x]'), function(index, value) {
      return $(this).attr('src', $(this).attr('data-at2x'));
    });
  }
}