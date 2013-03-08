T = require "../src/TermUI"
T.clear()
T.hideCursor()

tabs = new T.Tabs
	items: ["cat", "rat", "baseball bat"]


drawTabContent = (tab) -> 
	T.pos(1,4).eraseLine().out("Active tab content #{tab}")

tabs.on "activeTab", drawTabContent 

tabs.draw()
drawTabContent "cat"