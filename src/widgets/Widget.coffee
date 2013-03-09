T = require "../TermUI"
{EventEmitter} = require 'events'

class T.Widget extends EventEmitter
  constructor: (@options = {}) ->
    @bounds = 
      x: @options.bounds?.x or 1
      y: @options.bounds?.y or 1
      w: @options.bounds?.w or 1
      h: @options.bounds?.h or 1

    
    @_widgetIndex = (T.Widget.instances.push this) - 1
    @allowFocus = true 
    @visible = false

  calcDims: -> 
    this 
    
  disallowFocus: -> 
    @allowFocus = false
    this

  draw: ->
    @visible = true
    @emit "drawn"

  hitTest: (x, y) ->
    (@bounds.x <= x <= (@bounds.x + @bounds.w - 1)) and
    (@bounds.y <= y <= (@bounds.y + @bounds.h - 1))

  handleTab: -> 

  handleKey: (char, key) -> 
    if key?.name? and @["onKey_#{key.name}"]
      return @["onKey_#{key.name}"]()

  focus: ->
    return if T.Widget.activeInstance is this 
    T.Widget.activeInstance?.blur?()
    T.Widget.activeInstance = this
    T.Widget.activeIndex = @_widgetIndex

    @_active = true
    @emit "focus" 
    
    this

  blur: -> 
    @_active = false
    @emit "blur"
    this

T.Widget.instances = []
T.Widget.activeIndex = false
T.Widget.activeInstance = false
T.Widget.nextFocussableInstance = (loopAround = true) -> 
  for widget, windex in T.Widget.instances[T.Widget.activeIndex or 0..-1]
    if (widget isnt T.Widget.activeInstance) and widget.allowFocus and widget.visible
        return widget.focus()

  if loopAround 
    T.Widget.activeIndex = 0 
    T.Widget.nextFocussableInstance false

T.on "resize", -> 
  T.clear()
  for widget in T.Widget.instances 
    widget.draw()

T.on "keypress", (char, key) ->
  if T.Widget.instances.length 
    if key?.name is "tab"
      if T.Widget.activeInstance is false or (not T.Widget.activeInstance.handleTab())
        T.Widget.nextFocussableInstance()
    else if T.Widget.activeInstance
      T.Widget.activeInstance.handleKey char, key

T.on "any", (event, eventData) ->
  for widget in T.Widget.instances
    if widget.hitTest eventData.x, eventData.y
      eventData.target = widget
      widget.emit event, eventData