_ = require "underscore"
_.mixin require "underscore.string"

T = require "../TermUI"
B = require "../boxChars"

class T.Select extends T.Box
	constructor: (opts) ->
		super opts
		@activeItem = opts.activeItem ? false

	_drawRow: (x, y, content, index) -> 
		if @activeItem is index 
			bg = @contentColor 
			@contentColor = T.C.k
			T.saveBg().bg(bg)
			super x, y, content
			T.restoreBg()
			@contentColor = bg 
			@emit "change", @activeItem, @content[@activeItem]
		else
			super x, y, content

	onKey_up: -> 
		if @activeItem > 0
			@activeItem-- 
		super()

	onKey_down: -> 
		if @activeItem < @content.length - 1
			@activeItem++
		super()

