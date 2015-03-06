$.fn.slider.Constructor::disable = ->
  @enabled = false
  @picker.off()
  @handleEnabledStatus()
  return

$.fn.slider.Constructor::enable = ->
  if !@enabled
    @enabled = true
    @initializeEvents()
    @handleEnabledStatus()
  return
