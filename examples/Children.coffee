T = require "../src/TermUI"
T.clear()

box = new T.Box 
	bounds:
		x: 10
		y: 10
		w: "fit"
		h: "fit"
	children: [
		new T.Box 
			bounds:
				x: 20
				y: 1
				w: "fit"
				h: "fit"
			content: ["This is pushing the bounds... literally"]
		new T.Box
			bounds:
				x: 5
				y: 5
				w: 16
				h: 3
			roundedCorners: true
			content: ["This is nested"]
		new T.Box
			bounds:
				x: 10
				y: 15
				w: "fit"
				h: "fit"
			content: ["cat rabbit", "shim shabbit", "blim blabbit my mabbit"]
	]

box.draw()