T = require "../TermUI"
B = require "../boxChars"

T.clear()
T.hideCursor()

label = new T.Box
	bounds:
		x: 1
		y: 1
		w: 9
		h: 2
	borders:
		b: false
	content: ["Package"]

box = new T.Box
	bounds:
		x: 1
		y: 3
		w: 15
		h: 10
	content: ["CoffeeTalk", "My Project", "Backbone", "underscore", "random pkg", "another random", "really long one", "short", "overflow 1", "overflow 2", "overflow 3", "magical project", "datomic"]

box.on "drawn", -> 
	T.pos(box.bounds.x, box.bounds.y)
		.out(B.lightVerticalAndRight)
		.pos(label.bounds.x + label.bounds.w - 1, box.bounds.y)
		.out(B.lightUpAndHorizontal)
		.pos(box.bounds.x + box.bounds.w - 1, box.bounds.y)
		.out(B.lightDownAndHorizontal)
		.pos(box.bounds.x + box.bounds.w - 1, box.bounds.y + box.bounds.h - 1 )
		.out(B.lightUpAndHorizontal)

label.disallowFocus()
label.draw()
box.draw()


classLabel = new T.Box
	bounds:
		x: 15
		y: 1
		w: 7
		h: 2
	borders:
		b: false
	content: ["Class"]

cbox = new T.Box
	borders:
		l: false
	bounds: 
		x: 16
		y: 3
		w: 15
		h: 10
	content: ["cat", "rabbit", "another random badger", "elephant", "tiger", "lion", "dragon", "monkey", "ape", "horse", "liger", "apple", "pear", "carrot", "pepper", "squash", "strawberry", "pineapple", "raspberry", "blueberry", "cherry", "boisenberry", "blackberry", "cranberry", "gooseberry"]

classLabel.draw()
classLabel.disallowFocus()
cbox.draw()

###
(new T.Box
	bounds: 
		x: 35
		y: 5
		w: 15
		h: 10).draw()
###
T.end()
