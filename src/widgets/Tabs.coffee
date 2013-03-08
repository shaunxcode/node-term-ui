_ = require "underscore"
_.mixin require "underscore.string"

T = require "../TermUI"

B = require "../boxChars"

class T.Tabs extends T.Widget
	constructor: (opts) -> 
		super opts

		@x = opts.x ? 1
		@y = opts.y ? 1
		@items = opts.items ? []
		@lineColor = opts.lineColor ? T.C.g
		@textColor = opts.textColor ? T.C.g
		@spaceBefore = opts.spaceBefore ? 1
		@spaceBetween = opts.spaceBetween ? 1
		@activeTab = opts.activeTab ? @items[0] ? false
		@_tabBounds = {}
		@_focussed = false

	draw: -> 
		x = @x 
		y = @y 
				
		T.saveCursor().pos x, y

		for tab in @items
			width = tab.length + 2
			
			@_tabBounds[tab] = x: x, y: y, w: width, height: 3 

			T.pos(x, y + 2)
				.out(B.lightHorizontal)
				.pos(x + 1, y + 1)
				.out(B.lightVertical)
				.pos(x + 1, y)
				.out(B.lightDownAndRight)
				.pos(x + 2, y)
				.out(_.repeat B.lightHorizontal, width)
				.out(B.lightDownAndLeft)
				.pos(x + 2, y + 1)
				.out(tab)
				.out(" ×")	
				.out(B.lightVertical)
				.pos(x + 2, y + 2)

			T.pos(x + 1, y + 2)
			if tab is @activeTab
				T.out(B.lightUpAndLeft)
					.out(_.repeat " ", width)
					.out(B.lightUpAndRight)
			else
				T.out(B.lightUpAndHorizontal)
					.out(_.repeat B.lightHorizontal, width)
					.out(B.lightUpAndHorizontal)

			x += width + 3

		T.out(_.repeat B.lightHorizontal, T.width - (x - 1))

		T.restoreCursor()

	hitTest: (x, y) -> 
		T.pos(15, 15).out("x:#{x}, y:#{y}")
		for tab, bounds of @_tabBounds
			if (bounds.x <= x <= (bounds.x + bounds.w - 1)) and
    			(bounds.y <= y <= (bounds.y + bounds.h - 1))
    				@activeTab = tab 
    				@draw()
    				return true

	_label: (item, fg, bg) -> 
		bounds = @_tabBounds[item]
		T.pos(bounds.x + 2, bounds.y + 1)
			.saveFg().saveBg()
			.fg(fg).bg(bg)
			.out(item)
			.restoreFg().restoreBg()

	unfocus: ->
		@_label @items[@_focussed], T.C.g, T.C.k

	focus: ->
		@_label @items[@_focussed], T.C.k, T.C.g
		
	handleTab: -> 
		if @_focussed is false
			@_focussed = 0
		else
			@unfocus()
			@_focussed++

		if @_focussed is @items.length
			@_focussed = false
			return false

		@focus()

	handleKey: (char, key) -> 
		T.pos(15, 15).out(key.name)
