_ = require "underscore"
_.mixin require "underscore.string"

T = require "../TermUI"
B = require "../boxChars"

class T.Box extends T.Widget
	constructor: (opts = {}) -> 
		@renderChar = opts.renderChar ? false 
		@ellipsizeContent = opts.ellipsizeContent ? true
		@hideScrollers = opts.hideScrollers ? false 
		@content = opts.content ? []
		@children = opts.children ? []

		if opts.borders? and not opts.borders 
			@borders = l: false, r: false, t: false, b: false
		else
			@borders = _.extend(
				{l: true, r: true, t: true, b: true}
				opts.borders ? {})

		#calculate border dims
		@vbdiff = 0 
		@hbdiff = 0 

		if @borders.l then @hbdiff++
		if @borders.r then @hbdiff++
		if @borders.t then @vbdiff++
		if @borders.b then @vbdiff++

		super opts	
		
		@scrollPos = 0 
		@scrollPosX = 0 

		@rightBorderChar = if @borders.r then (B 0, 0, 1, 1) else "" 
		@leftBorderChar = if @borders.l then (B 0, 0, 1, 1) else ""

		if opts.roundedCorners 
			@topLeftCorner = B 0, 6, 0, 6
			@topRightCorner = B 6, 0, 0, 6 
			@botLeftCorner = B 0, 6, 6, 0 
			@botRightCorner = B 6, 0, 6, 0 
		else
			@topLeftCorner = B 0, 1, 0, 1
			@topRightCorner = B 1, 0, 0, 1
			@botLeftCorner = B 0, 1, 1, 0 
			@botRightCorner = B 1, 0, 1, 0 

		@borderColor = opts.borderColor ? T.C.g 
		@contentColor = opts.contentColor ? T.C.g
		@calcDims()

	calcDims: -> 
		for k, v of @bounds 
			@bounds[k] = Math.floor v
	
		if @content.length
			T._d @content
			@widestContent = _.last(_.sortBy @content, (c) -> c.length).length 
		else
			@widestContent = 0 

		if @options.bounds?.w is "fit"
			if @content.length
				@bounds.w = @widestContent + @hbdiff 
			else
				@bounds.w = @widestContent

			for child in @children 
				if (nw = child.bounds.x + child.bounds.w + child.hbdiff) > @bounds.w
					@bounds.w = nw

		if @options.bounds?.h is "fit"
			if @content.length
				@bounds.h = @content.length + @vbdiff 
			else
				@bounds.h = 0 

			for child in @children 
				if (nh = child.bounds.y + child.bounds.h + child.vbdiff) > @bounds.h
					@bounds.h = nh
					
		@maxWidth = @bounds.w - @hbdiff
		@maxHeight = @bounds.h - @vbdiff
		@maxScrollY = @bounds.y + @maxHeight
		@maxScrollX = @bounds.x + @maxWidth 
		@contentRangeY = [@bounds.y+1..@bounds.y+@maxHeight]
		@rightBorderX = @bounds.x + @bounds.w - (if @borders.l then 1 else 0)

		for child in @children 
			child.bounds.x += @bounds.x 
			child.bounds.y += @bounds.y
			child.calcDims()

	setContent: (content) -> 
		@content = content 
		@calcDims()
		@draw()
		this
		
	setBounds: (bounds) -> 
		_.extend @bounds, bounds 
		@calcDims()
		@draw() 
		this
		
	setBorderColor: (c) -> 
		@borderColor = c
		this 

	draw: -> 
		return if @hidden 
		@drawBorders()
		@drawContent()
		super()
		
	drawBorders: ->
		T.hideCursor().saveFg().fg @borderColor
		if @borders.t 
			T.pos(@bounds.x, @bounds.y)
				.out(if @borders.l then @topLeftCorner else (B 1, 1, 0, 0))
				.out(_.repeat (B 1, 1, 0, 0), @bounds.w - @hbdiff)
				.out(if @borders.r then @topRightCorner else (B 1, 1, 0, 0))

		
		if @borders.b
			T.pos(@bounds.x, @bounds.y + @bounds.h - (Math.floor @vbdiff / 2))
				.out(if @borders.l then @botLeftCorner else (B 0, 0, 1, 1))
				.out(_.repeat (B 1, 1, 0, 0), @bounds.w - @hbdiff)
				.out(if @borders.r then @botRightCorner else (B 1, 1, 0, 0))

		
		for row in @contentRangeY
			T.pos(@bounds.x, row)
				.out(@leftBorderChar)
				.pos(@rightBorderX, row)
				.out(@rightBorderChar)
 		
 		
		T.restoreFg()

		if @content.length > @maxHeight then @scroll 0 
		@emit "bordersDrawn"


	_drawRow: (x, y, content, index) ->
		T.saveFg().saveBg().pos(x, y)

		if @renderChar
			for c in content
				if c?.char?
					T.fg(c.fg).bg(c.bg).out c.char
				else T.out " "
				
		else
			T.fg(@contentColor).out(content)
		
		T.restoreFg().restoreBg()

		this

	drawContent: ->
		l = 0 
		c = 0 
		@n = 35
		x = @bounds.x + (if @borders.l then 1 else 0)
		for line in @contentRangeY
			ci = @scrollPos + l++
			
			content = ""
			if @content[ci]?
				content = @content[ci][@scrollPosX..-1]

			if content.length > @maxWidth
				if @ellipsizeContent 
					content = content[0..@maxWidth-3] + ".."
				else 
					content = content[0..@maxWidth-1] 
			else if _.isString content
				content = _.rpad content, @maxWidth, " "

			@_drawRow x, line, content, ci 

		@drawChildren()

		@emit "contentDrawn"

		this

	drawChildren: -> 
		child.draw() for child in @children 
		this

	_scrollX: -> 
		if @scrollPosX is @widestContent - @maxWidth
			@maxScrollX 
		else
			per = @scrollPosX / (@widestContent - @maxWidth + 1)
			@bounds.x + Math.floor(@maxWidth * per) + 1

	_scrollY: -> 
		#get percentage we have scrolled
		if @scrollPos is @content.length - @maxHeight
			@maxScrollY 
		else
			per = @scrollPos / (@content.length - @maxHeight + 1)
			@bounds.y + Math.floor(@maxHeight * per) + 1

	hasScrollableContent: -> 
		@content.length > @maxHeight
		
	scroll: (byAmt) -> 
		if @content.length isnt 0 and not @hideScrollers and @hasScrollableContent()
			T.saveFg().fg(@borderColor)
			T.pos(@rightBorderX, @_scrollY())
				.out(@rightBorderChar) 

			@scrollPos += byAmt

			T.pos(@rightBorderX, @_scrollY())
				.out(B 0, 0, 3, 3)

			T.restoreFg()
		else
			@scrollPos += byAmt

		@drawContent()

	scrollX: (byAmt) -> 
		@scrollPosX += byAmt
		@drawContent()

	onKey_up: ->
		return if @content.length is 0 

		if @scrollPos is 0 
			@scroll 0
		else
			@scroll -1

	onKey_down: -> 
		return if @content.length is 0 

		if (@scrollPos is @content.length - @maxHeight) or (not @hasScrollableContent())
			@scroll 0 
		else
			@scroll 1 

	onKey_left: -> 
		return if @content.length is 0 

		if @scrollPosX is 0 
			@scrollX 0 
		else
			@scrollX -1

	onKey_right: -> 
		return if @content.length is 0 

		if @scrollPosX is @widestContent - @maxWidth
			@scrollX 0 
		else 
			@scrollX 1

	focus: -> 
		super()
		@setBorderColor T.C.y 
		@drawBorders()
		this

	blur: -> 
		super()
		@setBorderColor T.C.g
		@drawBorders()

