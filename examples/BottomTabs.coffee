T = require "../src/TermUI"
T.clear()
T.hideCursor()

tabs = new T.Tabs
	x: 15
	y: 10
	activeTab: false
	position: "bottom"
	items: [["cat", "some sort of cat"], "rat", "baseball bat"]

tabs.draw()

box = new T.Box 
	bounds:
		x: 14
		y: 5
		w: tabs.width + 2
		h: 5
	borders: 
		b: false

box.on "bordersDrawn", ->
	T._d "DRAWN SON"
	T.pos(box.bounds.x, box.bounds.y + box.bounds.h).out T.B 0, 1, 1, 0
	T.pos(box.bounds.x + box.bounds.w - 1, box.bounds.y + box.bounds.h).out T.B 1, 0, 1, 0
	
tabs.draw()
drawTabContent = (tab, display) -> 
	box.setContent ["Active tab content #{tab}", "Containing: #{display}"]
	
tabs.on "activeTab", drawTabContent 
drawTabContent "cat", "whisker cheese"