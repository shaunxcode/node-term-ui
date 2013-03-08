T = require "../src/TermUI"
T.hideCursor()
T.clear()

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

name.on "change", -> 
	T.pos(10,18).eraseLine().out "NAME: " + name.val()