util = require 'util'
tty = require 'tty'
keypress = require 'keypress'
{EventEmitter} = require 'events'
_ = require 'underscore'
_.mixin require 'underscore.string'

hex = (color) ->
  c = if color[0]is '#' then color.substring(1) else color
  [
    parseInt c.substring(0, 2), 16
    parseInt c.substring(2, 4), 16
    parseInt c.substring(4, 6), 16
  ]

rgb5 = (r, g, b) ->
  16 + (Math.round(r)*36) + (Math.round(g)*6) + Math.round(b)

rgb = (r, g, b) -> 
  rgb5 r / 255 * 5, g / 255 * 5, b / 255 * 5

# ===============================================================[ TermUI ]====
module.exports = T = new class TermUI extends EventEmitter
  constructor: ->

    if tty.isatty process.stdin
      keypress process.stdin
      process.stdin.setRawMode true
      process.stdin.resume()

      process.stdin.on 'keypress', @handleKeypress
      process.stdin.on 'data', @handleData

      if process.listeners('SIGWINCH').length is 0
        process.on 'SIGWINCH', @handleSizeChange

      @handleSizeChange()

      @enableMouse()
      
      @_bg = @C.k
      @_fg = @C.g

      @isTerm = true
    else
      @isTerm = false

  C: { k: 0, r: 1, g: 2, y: 3, b: 4, m: 5, c: 6, w: 7, x: 9 }

  S: { normal: 0, bold: 1, underline: 4, blink: 5, inverse: 8 }

  SYM: {
    star: '\u2605',
    check: '\u2714',
    x: '\u2718',
    triUp: '\u25b2',
    triDown: '\u25bc',
    triLeft: '\u25c0',
    triRight: '\u25b6',
    fn: '\u0192',
    arrowUp: '\u2191',
    arrowDown: '\u2193',
    arrowLeft: '\u2190',
    arrowRight: '\u2192'
  }

  handleSizeChange: =>
    winsize = process.stdout.getWindowSize()
    @width = winsize[0]
    @height = winsize[1]
    @emit 'resize', {w: @width, h: @height}

  out: (buf) ->
    if @isTerm
      process.stdout.write(buf)
    this

  hideCursor: ->
    @out '\x1b[?25l'
    this

  showCursor: ->
    @out '\x1b[?25h'
    this

  saveCursor: -> 
    @out '\x1b7'
    this

  restoreCursor: -> 
    @out '\x1b8'
    this

  clear: ->
    @out '\x1b[2J'
    @home()
    this

  pos: (x, y) ->
    x = if x < 0 then @width - x else x
    y = if y < 0 then @height - y else y
    x = Math.max(Math.min(x, @width), 1)
    y = Math.max(Math.min(y, @height), 1)
    @out "\x1b[#{y};#{x}H"
    this

  home: ->
    @pos 1, 1
    this

  end: ->
    @pos 1, -1
    this

  fgRgb: (r, g, b) ->
    @fg "8;5;#{rgb r, g, b}"

  fgHex: (h) ->
    [r, g, b] = hex h 
    @fgRgb r, g, b

  fg: (c) ->
    @_fg = c
    @out "\x1b[3#{c}m"
    this

  saveFg: -> 
    @_savedFg = @_fg 
    this

  restoreFg: ->
    @fg @_savedFg
    this

  bg: (c) ->
    @_bg = c
    @out "\x1b[4#{c}m"
    this

  saveBg: ->
    @_savedBg = @_bg
    this

  restoreBg: ->
    @bg @_savedBg
    this

  hifg: (c) ->
    @out "\x1b[38;5;#{c}m"
    this

  hibg: (c) ->
    @out "\x1b[48;5;#{c}m"
    this

  enableMouse: ->
    keypress.enableMouse process.stdout
    this

  disableMouse: ->
    keypress.disableMouse process.stdout
    this

  eraseLine: ->
    @out '\x1b[2K'
    this

  eraseToEnd: -> 
    @out '\x1b[K'
    this

  handleKeypress: (c, key) =>
    if (key && key.ctrl && key.name == 'c')
      @quit()
    else
      @emit 'keypress', c, key

  handleData: (d) =>
    eventData = {}
    buttons = [ 'left', 'middle', 'right' ]

    if d[0] is 0x1b and d[1] is 0x5b && d[2] is 0x4d # mouse event

      switch (d[3] & 0x60)

        when 0x20 # button
          if (d[3] & 0x3) < 0x3
            event = 'mousedown'
            eventData.button = buttons[ d[3] & 0x3 ]
          else
            event = 'mouseup'

        when 0x40 # drag
          event = 'drag'
          if (d[3] & 0x3) < 0x3
            eventData.button = buttons[ d[3] & 0x3 ]

        when 0x60 # scroll
          event = 'wheel'
          if d[3] & 0x1
            eventData.direction = 'down'
          else
            eventData.direction = 'up'

      eventData.shift = (d[3] & 0x4) > 0
      eventData.x = d[4] - 32
      eventData.y = d[5] - 32

      @emit event, eventData
      @emit 'any', event, eventData

  quit: ->
    @fg(@C.x)
      .bg(@C.x)
      .disableMouse()
      .showCursor()
      .clear()

    process.stdin.setRawMode false
    process.exit()


# ===============================================================[ Widget ]====
class T.Widget extends EventEmitter
  constructor: (@options = {}) ->
    @bounds = 
      x: @options.bounds?.x or 0
      y: @options.bounds?.y or 0
      w: @options.bounds?.w or 0
      h: @options.bounds?.h or 0

    T.Widget.instances.push this
    @allowFocus = true 

  disallowFocus: -> 
    @allowFocus = false
    this

  draw: ->
    @emit "drawn"

  hitTest: (x, y) ->
    (@bounds.x <= x <= (@bounds.x + @bounds.w - 1)) and
    (@bounds.y <= y <= (@bounds.y + @bounds.h - 1))

  handleTab: -> 

  handleKey: (char, key) -> 
    if @["onKey_#{key.name}"]
      return @["onKey_#{key.name}"]()

  focus: -> 
    @_active = true 
    this

  blur: -> 
    @_active = false
    this

T.Widget.instances = []
T.Widget.activeIndex = false
T.Widget.activeInstance = false
T.Widget.nextFocussableInstance = (loopAround = true) -> 
  #focus new 

  for widget, windex in T.Widget.instances[T.Widget.activeIndex..-1]
    if widget isnt T.Widget.activeInstance and widget.allowFocus
      if T.Widget.activeInstance
        T.Widget.activeInstance.blur()
      T.Widget.activeIndex = windex
      T.Widget.activeInstance = widget 
      T.Widget.activeInstance.focus()
      return 

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

require "./widgets/Button"
require "./widgets/Box"
require "./Widgets/Tabs"
require "./Widgets/Select"
require "./Widgets/TextInput"