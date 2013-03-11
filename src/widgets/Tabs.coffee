_ = require "underscore"
_.mixin require "underscore.string"

T = require "../TermUI"

class T.Tabs extends T.Widget
	constructor: (opts) -> 
		super opts

		@position = opts.position ? "top"
		@x = opts.x ? 1
		@y = opts.y ? 1

		@items =(for tab in (opts.items ? [])
			if not _.isArray tab
				[tab, tab]
			else
				tab)

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
			[tabId, tab] = tab
				
			width = tab.length 
			
			@_tabBounds[tabId] = x: x, y: y, w: width, height: 3 

			if @position is "top"
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
					.out(T.B 0, 0, 1, 1)
					.pos(x + 2, y + 2)

				T.pos(x + 1, y + 2)
				if tabId is @activeTab
					T.out(T.B 1, 0, 1, 0)
						.out(_.repeat " ", width)
						.out(T.B 0, 1, 1, 0)
				else
					T.out(T.B 1, 1, 1, 0)
						.out(_.repeat (T.B 1, 1, 0 ,0), width)
						.out(T.B 1, 1, 1, 0)
			else if @position is "bottom"
				T.pos(x, y)
					.out(T.B 1, 1, 0, 0)
					.pos(x + 1, y + 1)
					.out(T.B 0, 0, 1, 1)
					.pos(x + 1, y + 2)
					.out(T.B 0, 1, 1, 0) 
					.pos(x + 2, y + 2)
					.out(_.repeat (T.B 1, 1, 0, 0), width)
					.out(T.B 1, 0, 1, 0)
					.pos(x + 2, y + 1)
					.out(tab)
					.out(T.B 0, 0, 1, 1)

				T.pos(x + 1, y)
				if tabId is @activeTab
					T.out(T.B 1, 0, 0, 1)
						.out(_.repeat " ", width)
						.out(T.B 0, 1, 0, 1)
				else
					T.out(T.B 1, 1, 0, 1)
						.out(_.repeat (T.B 1, 1, 0 ,0), width)
						.out(T.B 1, 1, 0, 1)


			x += width + 3
			
		@width = x - @x
		T.restoreCursor()
		super()
		
	hitTest: (x, y) -> 
		T.pos(15, 15).out("x:#{x}, y:#{y}")
		for tabId, bounds of @_tabBounds
			if (bounds.x <= x <= (bounds.x + bounds.w - 1)) and
    			(bounds.y <= y <= (bounds.y + bounds.h - 1))
    				@activeTab = tabId
    				@draw()
    				return true

	_label: (item, fg, bg) -> 
		[tabId, tab] = item
		bounds = @_tabBounds[tabId]

		T.pos(bounds.x + 2, bounds.y + 1)
			.saveFg().saveBg()
			.fg(fg).bg(bg)
			.out(tab)
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
			@activeTab = @items[@_focussed][0]
			@draw()
			@focusTab()
			@emit "activeTab", @activeTab, @items[@_focussed][1]

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