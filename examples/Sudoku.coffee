T = require "../TermUI"

x = 0 
y = 0
grid = {}

draw = -> 
	grid[x][y].focus()

check = -> 
	cellError = []

	checkNum = (nums, x, y) -> 
		cell = grid[x][y]
		if cell.val() in nums
			cell.textColor T.C.r 
			cellError.push cell.key()
		else
			if cell.key() not in cellError 
				cell.textColor T.C.g
			nums.push cell.val()

	#check each square
	for colOffset in [0..2]
		for rowOffset in [0..2]
			nums = []
			checks = []
			for row in [0..2]
				for col in [0..2]
					checkNum nums, col + (colOffset * 3), row + (rowOffset * 3) 

	#check each col and row
	for row in [0..8]
		cnums = []
		rnums = []
		for col in [0..8]
			checkNum cnums, col, row
			checkNum rnums, row, col 

class SudokuInput extends T.TextInput
	constructor: (opts) -> 
		super opts 

		@x = opts.x 
		@y = opts.y
		@maxLength = 1 

	charValidation: (val) -> 
		/[1-9]/.test val 

	onKey_up: -> 
		if y > 0 then y--
		draw()

	onKey_down: -> 
		if y < 8 then y++
		draw()

	onKey_left: -> 
		if x > 0 then x--
		draw()

	onKey_right: -> 
		if x < 8 then x++
		draw()

	onKey_space: -> 
		@content = []
		check()
		@drawContent()
		@drawCursor()

	focus: ->
		x = @x
		y = @y 
		super()
	
	key: -> 
		"#{@x}x#{@y}"

	val: -> 
		parseInt super()

	scroll: -> 

do (x, y) -> 
	for x in [0..8]
		grid[x] = {}
		for y in [0..8]
			grid[x][y] = new SudokuInput {x, y, borders: false}
			grid[x][y].on "change", check 

	styler = (r) -> if r%3 is 0 then 3 else 1

	g = new T.Grid
		cols: 9
		rows: 9
		cellWidth: 1
		cellHeight: 1
		rowStyle: styler
		colStyle: styler 
		content: grid 

	T.clear()
	g.draw()
