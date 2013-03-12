T = require "../src/TermUI"

b = new T.Box 
	renderChar: true
	bounds: 
		w: 75
		h: 25



board = []
max = 0 
for p in T.G.circle {x: 20, z: 10}, 10
	if not board[p.z] 
		board[p.z] = []
	board[p.z][p.x] = {fg: T.C.b, bg: T.C.b, char: " "}
	if p.x > max then max = p.x

for line, l in board
	if not line
		board[l] = []
		
	for c in [0..max + 10]
		if not board[l][c]
			board[l][c] = {fg: T.C.k, bg: T.C.k, char: " "}

b.setContent board
