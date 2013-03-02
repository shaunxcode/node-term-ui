T = require "../TermUI"

class T.TextInput extends T.Box
	initialize: (opts) ->
		super opts
		 
		@lines = opts.lines ? 1

	focus: -> 
		super()
		T.pos(@bounds.x + 1, @bounds.y + 1).showCursor()

	drawContent: -> 
		T.pos(@bounds.x + 1, @bounds.y + 1).out @content.join ""

	handleKey: (char, key) ->
		@content.push char 
		@drawContent()

		this 

	onKey_left: -> 

	onKey_right: -> 
