fs = require "fs"
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
_dc = 0
module.exports = T = new class TermUI extends EventEmitter
  _d: (vals...) ->
    fs.appendFile "#{process.cwd()}/_term-ui-debug.log", "#{_dc++}: #{(JSON.stringify x for x in vals).join " "}\n"

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

  B: require "./boxChars"
  
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
      process.stdout.write(String buf)
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
    x = Math.floor Math.max Math.min(x, @width), 1
    y = Math.floor Math.max Math.min(y, @height), 1
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


require "./widgets/Widget"
require "./widgets/Button"
require "./widgets/Box"
require "./widgets/Tabs"
require "./widgets/Select"
require "./widgets/TextInput"
require "./widgets/Grid"