T = require "../src/TermUI"
T.clear()
T.hideCursor()

tabs = new T.Tabs
	items: ["cat", "rat", "baseball bat"]

tabs.draw()