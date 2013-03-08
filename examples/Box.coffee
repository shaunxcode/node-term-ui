T = require "../src/TermUI"
B = require "../src/boxChars"

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

label.disallowFocus()
label.draw()
box.draw()

classLabel = new T.Box
	bounds:
		x: 17
		y: 1
		w: 7
		h: 2
	borders:
		b: false
	content: ["Class"]

cbox = new T.Box
	bounds: 
		x: 17
		y: 3
		w: 15
		h: 10
	content: ["cat", "rabbit", "another random badger", "elephant", "tiger", "lion", "dragon", "monkey", "ape", "horse", "liger", "apple", "pear", "carrot", "pepper", "squash", "strawberry", "pineapple", "raspberry", "blueberry", "cherry", "boisenberry", "blackberry", "cranberry", "gooseberry"]

classLabel.draw()
classLabel.disallowFocus()
cbox.draw()

T.end()
###