T = require "../TermUI"
T.hideCursor()

input = new T.TextInput
	bounds:
		x: 10
		y: 10
		h: 3
		w: 15

input.draw()

name = new T.TextInput
	bounds:
		x: 10
		y: 15
		h: 3
		w: 15

name.draw()