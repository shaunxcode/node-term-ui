_ = require "underscore"
_.mixin require "underscore.string"

T = require "../TermUI"

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
				.out(T.B 1, 1, 0, 0)
				.pos(x + 1, y + 1)
				.out(T.B 0, 0, 1, 1)
				.pos(x + 1, y)
				.out(T.B 0, 1, 0, 1) 
				.pos(x + 2, y)
				.out(_.repeat (T.B 1, 1, 0, 0), width)
				.out(T.B 1, 0, 0, 1)
				.pos(x + 2, y + 1)
				.out(tab)
				.out(" ×")	
				.out(T.B 0, 0, 1, 1)
				.pos(x + 2, y + 2)

			T.pos(x + 1, y + 2)
			if tab is @activeTab
				T.out(T.B 1, 0, 1, 0)
					.out(_.repeat " ", width)
					.out(T.B 0, 1, 1, 0)
			else
				T.out(T.B 1, 1, 1, 0)
					.out(_.repeat (T.B 1, 1, 0 ,0), width)
					.out(T.B 1, 1, 1, 0)

			x += width + 3

		T.out(_.repeat (T.B 1, 1, 0, 0), T.width - (x - 1))

		T.restoreCursor()
		super()
		
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

	unfocusTab: ->
		if @_focussed isnt false
			@_label @items[@_focussed], T.C.g, T.C.k

	focusTab: ->
		@_label @items[@_focussed], T.C.k, T.C.g
		
	focus: -> 
		super()
		@handleTab()

	handleTab: -> 
		@unfocusTab()
		if @_focussed is false
			@_focussed = 0
		else
			@_focussed++

		if @_focussed is @items.length
			@_focussed = false
			return false

		@focusTab()

	onKey_space: -> 
		if @_focussed isnt false 
			@activeTab = @items[@_focussed]
			@draw()
			@focusTab()
			@emit "activeTab", @activeTab  

	onKey_left: -> 
		@unfocusTab()

		if @_focussed is 0 
			@_focussed = @items.length - 1
		else 
			@_focussed--

		@focusTab() 

	onKey_right: -> 
		@unfocusTab()

		@_focussed++

		if @_focussed is @items.length
			@_focussed = 0 

		@focusTab()