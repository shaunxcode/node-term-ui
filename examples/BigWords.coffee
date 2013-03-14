T = require "../src/TermUI"

T.clear()
T.hideCursor()

bigwords = (words) -> (T.BigWords.convert words).split "\n"

box = new T.Box
	bounds:
		w: T.width 
		h: T.height
	content: ["first let us demonstrate the lowercase letters"]
		.concat(bigwords "abcdefghijklmnop")
		.concat(bigwords "qrstuvwxyz")
		.concat(["And then the uppercase"])
		.concat(bigwords "ABCDEFGHIJKLMNOP")
		.concat(bigwords "QRSTUVWXYZ[]<>`~|")
		.concat(bigwords "0123456789{},.:;?")
		.concat(bigwords "!@#$%^&*()-_+=\\/")
		.concat(["Some lisp just for fun"])
		.concat(bigwords "(lambda (X y) (+ X y))")
		.concat(["a little bit of coffee for good measure"])
		.concat(bigwords "[\"%\"]mod.exp = {cat: -> !@rat()}")
	
box.draw().focus()

T.on "resize", -> 
	box.setBounds w: T.width, h: T.height