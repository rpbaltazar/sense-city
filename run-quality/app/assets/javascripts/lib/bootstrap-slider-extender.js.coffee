$.fn.slider.Constructor::disable = ->
  @enabled = false
  @picker.off()
  return

$.fn.slider.Constructor::enable = ->
  if !@enabled
    @enabled = true
    @initializeEvents()
  return
