T = require "../TermUI"


T.clear()
T.hideCursor()

g = new T.Grid
	cols: 5
	rows: 5
	cellWidth: 10
	cellHeight: 1

g.draw()