### =========================================================
# bootstrap-slider.js v2.0.0
# http://www.eyecon.ro/bootstrap-slider
# =========================================================
# Copyright 2012 Stefan Petre
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ========================================================= 
###

!(($) ->

  Slider = (element, options) ->
    @element = $(element)
    @picker = $('<div class="slider">' + '<div class="slider-track">' + '<div class="slider-selection"></div>' + '<div class="slider-handle"></div>' + '<div class="slider-handle"></div>' + '</div>' + '<div class="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>' + '</div>').insertBefore(@element).append(@element)
    @id = @element.data('slider-id') or options.id
    if @id
      @picker[0].id = @id
    if typeof Modernizr != 'undefined' and Modernizr.touch
      @touchCapable = true
    tooltip = @element.data('slider-tooltip') or options.tooltip
    @tooltip = @picker.find('.tooltip')
    @tooltipInner = @tooltip.find('div.tooltip-inner')
    @orientation = @element.data('slider-orientation') or options.orientation
    switch @orientation
      when 'vertical'
        @picker.addClass 'slider-vertical'
        @stylePos = 'top'
        @mousePos = 'pageY'
        @sizePos = 'offsetHeight'
        @tooltip.addClass('right')[0].style.left = '100%'
      else
        @picker.addClass('slider-horizontal').css 'width', @element.outerWidth()
        @orientation = 'horizontal'
        @stylePos = 'left'
        @mousePos = 'pageX'
        @sizePos = 'offsetWidth'
        @tooltip.addClass('top')[0].style.top = -@tooltip.outerHeight() - 14 + 'px'
        break
    @min = @element.data('slider-min') or options.min
    @max = @element.data('slider-max') or options.max
    @step = @element.data('slider-step') or options.step
    @value = @element.data('slider-value') or options.value
    @enabled = @element.data('slider-enabled') or options.enabled
    if @value[1]
      @range = true
    @selection = @element.data('slider-selection') or options.selection
    @selectionEl = @picker.find('.slider-selection')
    if @selection == 'none'
      @selectionEl.addClass 'hide'
    @selectionElStyle = @selectionEl[0].style
    @handle1 = @picker.find('.slider-handle:first')
    @handle1Stype = @handle1[0].style
    @handle2 = @picker.find('.slider-handle:last')
    @handle2Stype = @handle2[0].style
    handle = @element.data('slider-handle') or options.handle
    switch handle
      when 'round'
        @handle1.addClass 'round'
        @handle2.addClass 'round'
      when 'triangle'
        @handle1.addClass 'triangle'
        @handle2.addClass 'triangle'
    if @range
      @value[0] = Math.max(@min, Math.min(@max, @value[0]))
      @value[1] = Math.max(@min, Math.min(@max, @value[1]))
    else
      @value = [ Math.max(@min, Math.min(@max, @value)) ]
      @handle2.addClass 'hide'
      if @selection == 'after'
        @value[1] = @max
      else
        @value[1] = @min
    @diff = @max - @min
    @percentage = [
      (@value[0] - @min) * 100 / @diff
      (@value[1] - @min) * 100 / @diff
      @step * 100 / @diff
    ]
    @offset = @picker.offset()
    @size = @picker[0][@sizePos]
    @formater = options.formater
    @layout()
    @initializeEvents = =>
      console.log 'Enabled?', @enabled
      if @enabled
        if @touchCapable
          # Touch: Bind touch events:
          @picker.on touchstart: $.proxy(@mousedown, this)
        else
          @picker.on mousedown: $.proxy(@mousedown, this)

      if tooltip == 'show'
        @picker.on
          mouseenter: $.proxy(@showTooltip, this)
          mouseleave: $.proxy(@hideTooltip, this)
      else
        @tooltip.addClass 'hide'
    @initializeEvents()

    return

  Slider.prototype =
    constructor: Slider
    over: false
    inDrag: false
    showTooltip: ->
      @tooltip.addClass 'in'
      #var left = Math.round(this.percent*this.width);
      #this.tooltip.css('left', left - this.tooltip.outerWidth()/2);
      @over = true
      return
    hideTooltip: ->
      if @inDrag == false
        @tooltip.removeClass 'in'
      @over = false
      return
    layout: ->
      @handle1Stype[@stylePos] = @percentage[0] + '%'
      @handle2Stype[@stylePos] = @percentage[1] + '%'
      if @orientation == 'vertical'
        @selectionElStyle.top = Math.min(@percentage[0], @percentage[1]) + '%'
        @selectionElStyle.height = Math.abs(@percentage[0] - @percentage[1]) + '%'
      else
        @selectionElStyle.left = Math.min(@percentage[0], @percentage[1]) + '%'
        @selectionElStyle.width = Math.abs(@percentage[0] - @percentage[1]) + '%'
      if @range
        @tooltipInner.text @formater(@value[0]) + ' : ' + @formater(@value[1])
        @tooltip[0].style[@stylePos] = @size * (@percentage[0] + (@percentage[1] - @percentage[0]) / 2) / 100 - (if @orientation == 'vertical' then @tooltip.outerHeight() / 2 else @tooltip.outerWidth() / 2) + 'px'
      else
        @tooltipInner.text @formater(@value[0])
        @tooltip[0].style[@stylePos] = @size * @percentage[0] / 100 - (if @orientation == 'vertical' then @tooltip.outerHeight() / 2 else @tooltip.outerWidth() / 2) + 'px'
      return
    mousedown: (ev) ->
      # Touch: Get the original event:
      if @touchCapable and ev.type == 'touchstart'
        ev = ev.originalEvent
      @offset = @picker.offset()
      @size = @picker[0][@sizePos]
      percentage = @getPercentage(ev)
      if @range
        diff1 = Math.abs(@percentage[0] - percentage)
        diff2 = Math.abs(@percentage[1] - percentage)
        @dragged = if diff1 < diff2 then 0 else 1
      else
        @dragged = 0
      @percentage[@dragged] = percentage
      @layout()
      if @touchCapable
        # Touch: Bind touch events:
        $(document).on
          touchmove: $.proxy(@mousemove, this)
          touchend: $.proxy(@mouseup, this)
      else
        $(document).on
          mousemove: $.proxy(@mousemove, this)
          mouseup: $.proxy(@mouseup, this)
      @inDrag = true
      val = @calculateValue()
      @element.trigger(
        type: 'slideStart'
        value: val).trigger
        type: 'slide'
        value: val
      false
    mousemove: (ev) ->
      # Touch: Get the original event:
      if @touchCapable and ev.type == 'touchmove'
        ev = ev.originalEvent
      percentage = @getPercentage(ev)
      if @range
        if @dragged == 0 and @percentage[1] < percentage
          @percentage[0] = @percentage[1]
          @dragged = 1
        else if @dragged == 1 and @percentage[0] > percentage
          @percentage[1] = @percentage[0]
          @dragged = 0
      @percentage[@dragged] = percentage
      @layout()
      val = @calculateValue()
      @element.trigger(
        type: 'slide'
        value: val).data('value', val).prop 'value', val
      false
    mouseup: (ev) ->
      if @touchCapable
        # Touch: Bind touch events:
        $(document).off
          touchmove: @mousemove
          touchend: @mouseup
      else
        $(document).off
          mousemove: @mousemove
          mouseup: @mouseup
      @inDrag = false
      if @over == false
        @hideTooltip()
      @element
      val = @calculateValue()
      @element.trigger(
        type: 'slideStop'
        value: val).data('value', val).prop 'value', val
      false
    calculateValue: ->
      val = undefined
      if @range
        val = [
          @min + Math.round(@diff * @percentage[0] / 100 / @step) * @step
          @min + Math.round(@diff * @percentage[1] / 100 / @step) * @step
        ]
        @value = val
      else
        val = @min + Math.round(@diff * @percentage[0] / 100 / @step) * @step
        @value = [
          val
          @value[1]
        ]
      val
    getPercentage: (ev) ->
      if @touchCapable
        ev = ev.touches[0]
      percentage = (ev[@mousePos] - @offset[@stylePos]) * 100 / @size
      percentage = Math.round(percentage / @percentage[2]) * @percentage[2]
      Math.max 0, Math.min(100, percentage)
    getValue: ->
      if @range
        return @value
      @value[0]
    setValue: (val) ->
      @value = val
      if @range
        @value[0] = Math.max(@min, Math.min(@max, @value[0]))
        @value[1] = Math.max(@min, Math.min(@max, @value[1]))
      else
        @value = [ Math.max(@min, Math.min(@max, @value)) ]
        @handle2.addClass 'hide'
        if @selection == 'after'
          @value[1] = @max
        else
          @value[1] = @min
      @diff = @max - @min
      @percentage = [
        (@value[0] - @min) * 100 / @diff
        (@value[1] - @min) * 100 / @diff
        @step * 100 / @diff
      ]
      @layout()
      return

  $.fn.slider = (option, val) ->
    @each ->
      $this = $(this)
      data = $this.data('slider')
      options = typeof option == 'object' and option
      if !data
        $this.data 'slider', data = new Slider(this, $.extend({}, $.fn.slider.defaults, options))
      if typeof option == 'string'
        data[option] val
      return

  $.fn.slider.defaults =
    min: 0
    enabled: true
    max: 10
    step: 1
    orientation: 'horizontal'
    value: 5
    selection: 'before'
    tooltip: 'show'
    handle: 'round'
    formater: (value) ->
      value
  $.fn.slider.Constructor = Slider
  return
)(window.jQuery)
