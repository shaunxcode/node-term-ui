_ = require "underscore"
_.mixin require "underscore.string"
T = require "../TermUI"
B = require "../boxChars"

class T.Grid extends T.Widget
	constructor: (opts = {}) -> 
		super opts
		@rows = opts.rows ? 2
		@cols = opts.cols ? 2
		@cellWidth = opts.cellWidth ? 1
		@cellHeight = opts.cellHeight ? 1
		@fit = opts.fit ? false
		@rowStyle = opts.rowStyle ? -> 1
		@colStyle = opts.colStyle ? -> 1
		@allowFocus = false 
		@content = opts.content ? {}

	draw: -> 
		maxRow = @rows + (@cellHeight * @rows)
		maxCol = @cols + (@cellWidth * @cols)
		x = 0 
		y = 0 
		for row in [0..maxRow] by @cellHeight + 1
			r = @rowStyle row + (@cellHeight * row)
			x = 0
			for col in [0..maxCol] by @cellWidth + 1
				if @content[x]?[y]?
					@content[x][y].bounds.x = @bounds.x + col
					@content[x][y].bounds.y = @bounds.y + row
					@content[x][y].draw()

				c = @colStyle col + (@cellWidth * col)
				T.pos @bounds.x + col, @bounds.y + row
				T.out(
					#top row
					if row is 0
						#left col
						if col is 0 
							B 0, r, 0, c
						#mid col 
						else if col < maxCol
							B r, r, 0, c
						#right col 
						else
							B r, 0, 0, c 
					#middle row
					else if row < maxRow
						#left col 
						if col is 0 
							B 0, r, c, c 
						#mid col 
						else if col < maxCol 
							B r, r, c, c
						#right col
						else
							B r, 0, c, c
					#bottom row
					else
						#left col 
						if col is 0
							B 0, r, c, 0
						#mid col
						else if col < maxCol
							B r, r, c, 0
						#right col 
						else
							B r, 0, c, 0)
				
				#filler 
				if row isnt maxRow
					for v in [0..@cellHeight]
						T.pos(@bounds.x + col, @bounds.y + row + 1 + v)
							.out B 0, 0, c, c 

				if col isnt maxCol 
					T.pos(@bounds.x + col + 1, @bounds.y + row)
						.out _.repeat B(r, r, 0, 0), @cellWidth
				x++
			y++

