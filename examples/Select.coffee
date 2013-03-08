T = require "../src/TermUI"
T.hideCursor()
T.clear()

select = new T.Select 
	bounds:
		x: 10
		y: 10
		w: 10
		h: 5
	content: ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m"]


select.draw()

other = new T.Select
	bounds:
		x: 20
		y: 10
		w: 10
		h: 5
	content: (String "num #{c}" for c in [1..15])

other.draw()

other.on "change", (index, item) -> 
	T.pos(20, 20).eraseLine().out "change event:" + JSON.stringify {index, item}