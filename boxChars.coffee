boxChars =
	0x2500: "lightHorizontal"
	0x2501: "heavyHorizontal"
	0x2502: "lightVertical"
	0x2503: "heavyVertical"
	0x2504: "lightTripleDashHorizontal"
	0x2505: "heavyTripleDashHorizontal"
	0x2506: "lightTripleDashVertical"
	0x2507: "heavyTripleDashVertical"
	0x2508: "lightQuadrupleDashHorizontal"
	0x2509: "heavyQuadrupleDashHorizontal"
	0x250A: "lightQuadrupleDashVertical"
	0x250B: "heavyQuadrupleDashVertical"
	0x250C: "lightDownAndRight"
	0x250D: "downLightAndRightHeavy"
	0x250E: "downHeavyAndRightLight"
	0x250F: "heavyDownAndRight"
	0x2510: "lightDownAndLeft"
	0x2518: "lightUpAndLeft"
	0x2514: "lightUpAndRight"
	0x251C: "lightVerticalAndRight"	
	0x2524: "lightVerticalAndLeft"
	0x2534: "lightUpAndHorizontal"
	0x252C: "lightDownAndHorizontal"
	0x254A: "leftLightAndRightVerticalHeavy"
	0x2525: "verticalLightAndLeftHeavy"
	0x2551: "doubleVertical"
	
codes = {}

for code, name of boxChars
	codes[name] = String.fromCharCode code

module.exports = codes