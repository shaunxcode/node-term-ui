_ = require "underscore"
_.mixin require "underscore.string"

T = require "../TermUI"
B = require "../boxChars"
_dl = 20
_d = (x) -> 
	T.pos(1,  _dl++).eraseLine().out("#{_dl}:#{JSON.stringify x}")
	if _dl > 30 then _dl = 19 
class T.Box extends T.Widget
	constructor: (opts) -> 
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

		if opts.bounds?.w is "fit"
			if @content.length
				opts.bounds.w = _.last(_.sortBy @content, (c) -> c.length).length + @hbdiff 
			else
				opts.bounds.w = 0 

			for child in @children 
				if (nw = child.bounds.x + child.bounds.w + child.hbdiff) > opts.bounds.w
					opts.bounds.w = nw

		if opts.bounds?.h is "fit"
			if @content.length
				opts.bounds.h = @content.length + @vbdiff 
			else
				opts.bounds.h = 0 

			for child in @children 
				if (nh = child.bounds.y + child.bounds.h + child.vbdiff) > opts.bounds.h
					opts.bounds.h = nh

		super opts	
		
		@scrollPos = 0 
		
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

		for child in @children 
			child.bounds.x += @bounds.x 
			child.bounds.y += @bounds.y
			child.calcDims()

	calcDims: -> 
		@maxWidth = @bounds.w - @hbdiff
		@maxHeight = @bounds.h - @vbdiff
		@maxScrollY = @bounds.y + @maxHeight
		@contentRange = [@bounds.y+1..@bounds.y+@maxHeight]
		@rightBorderX = @bounds.x + @bounds.w - (if @borders.l then 1 else 0)

	setBorderColor: (c) -> 
		@borderColor = c
		this 

	draw: -> 
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
			T.pos(@bounds.x, @bounds.y + @bounds.h - 1)
				.out(if @borders.l then @botLeftCorner else (B 0, 0, 1, 1))
				.out(_.repeat (B 1, 1, 0, 0), @bounds.w - @hbdiff)
				.out(if @borders.r then @botRightCorner else (B 1, 1, 0, 0))

		
		for row in @contentRange
			T.pos(@bounds.x, row)
				.out(@leftBorderChar)
				.pos(@rightBorderX, row)
				.out(@rightBorderChar)
 		
 		
		T.restoreFg()

		if @content.length > @maxHeight then @scroll 0 
		@emit "drawn"

	_drawRow: (x, y, content, index) -> 
		T.saveFg().fg(@contentColor)
		T.pos(x, y).out(content)
		T.restoreFg()
		this

	drawContent: ->
		l = 0 
		x = @bounds.x + (if @borders.l then 1 else 0)
		for line in @contentRange
			ci = @scrollPos + l++
			content = (@content[ci] ? "")
			 
			if content.length > @maxWidth
				content = content[0..@maxWidth-3] + ".."
			else
				content = _.rpad content, @maxWidth, " "

			@_drawRow x, line, content, ci 

		child.draw() for child in @children 

		@emit "contentDrawn"
		this

	_scrollY: -> 
		#get percentage we have scrolled
		if @scrollPos is @content.length - @maxHeight
			@maxScrollY 
		else
			per = @scrollPos / (@content.length - @maxHeight + 1)
			@bounds.y + Math.floor(@maxHeight * per) + 1

	scroll: (byAmt) -> 
		T.saveFg().fg @borderColor 

		T.pos(@rightBorderX, @_scrollY())
			.out(@rightBorderChar)

		@scrollPos = @scrollPos + byAmt

		T.pos(@rightBorderX, @_scrollY())
			.out(B 0, 0, 3, 3)

		T.restoreFg()

		@drawContent()

	onKey_up: ->
		if @scrollPos is 0 
			@scroll 0
		else
			@scroll -1

	onKey_down: -> 
		if @scrollPos is @content.length - @maxHeight
			@scroll 0 
		else
			@scroll 1 

	focus: -> 
		super()
		@setBorderColor T.C.y 
		@drawBorders()
  
	blur: -> 
		super()
		@setBorderColor T.C.g
		@drawBorders()

