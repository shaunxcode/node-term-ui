_ = require "underscore"
_.mixin require "underscore.string"
T = require "../TermUI"

class T.TextInput extends T.Box
	constructor: (opts) ->
		super opts
		 
		@lines = opts.lines ? 1
		@scrollPosX = 0 
		@cursorX = 0
		@cursorY = 0
		@maxLength = opts.maxLength ? false
		@fgColor = T.C.g 

	focus: -> 
		super()
		T.pos(@bounds.x + 1, @bounds.y + 1).showCursor()
		@drawCursor()

	drawContent: -> 
		T.hideCursor().saveFg().fg @fgColor

		if @content.length > @maxWidth
			content = @content[@scrollPosX..@scrollPosX + @maxWidth - 1].join ""
		else
			content = _.pad (@content.join ""), @maxWidth, " ", "right"

		T.pos(@bounds.x + 1, @bounds.y + 1).out(content).restoreFg()

	decCursorX: -> 
		if @cursorX > 0
			@cursorX--
		else if @scrollPosX > 0 
			@scrollPosX--
		this
		
	incCursorX: -> 
		if @cursorX < @maxWidth	- 1 and @cursorX < @content.length
			@cursorX++
		else if @scrollPosX < (@content.length - @maxWidth)
			@scrollPosX++
		this
		
	drawCursor: -> 
		T.pos(@bounds.x + 1 + @cursorX, @bounds.y + 1 + @cursorY).showCursor() 
		this 
		
	handleKey: (char, key) ->
		return if super char, key
		
		if @charValidation and not @charValidation char 
			@emit "invalidChar", char 
			return 

		if @content.length is @maxLength
			@content[@content.length-1] = char
		else
			pos = @scrollPosX + @cursorX
			@content[pos...] = [char].concat @content[pos...]

			if @content.length > @maxWidth
				@scrollPosX++

		@emit "change"      
		@incCursorX()
		@drawContent()
		@drawCursor()
		this 

	onKey_backspace: -> 
		pos = @scrollPosX + @cursorX

		if pos is 1
			@content = []
		else
			@content = @content[0..pos-2].concat @content[pos...]

		if @scrollPosX > 0
			@scrollPosX--
		else
			@decCursorX()

		@emit "change"
		@drawContent()
		@drawCursor()

	onKey_left: -> 
		@decCursorX()
		@drawContent()
		@drawCursor()
		
	onKey_right: ->
		@incCursorX()
		@drawContent()
		@drawCursor()
		
	onKey_enter: -> 
		console.log "enter"

	textColor: (color) -> 
		@fgColor = color 
		@drawContent()
		this

	val: -> 
		@content.join ""
		