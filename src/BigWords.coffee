T = require "./TermUI"

Chars = 
	thin:
		A: T.B 1, 0, 0, 1
		B: T.B 0, 1, 0, 1
		C: T.B 1, 0, 1, 0
		D: T.B 0, 1, 1, 0
		E: T.B 0, 0, 1, 1
		F: T.B 1, 1, 0, 0
		G: T.B 0, 1, 1, 1
		H: T.B 1, 0, 1, 1
		I: T.B 1, 1, 0, 1
		J: T.B 1, 1, 1, 0
		K: T.B 1, 1, 1, 1
		L: "╷"
		M: "╵"
		N: T.B 1, 1, 0, 0
		O: "╶"
	thick: 
		A: T.B 2, 0, 0, 2
		B: T.B 0, 2, 0, 2
		C: T.B 2, 0, 2, 0
		D: T.B 0, 2, 2, 0
		E: T.B 0, 0, 2, 2
		F: T.B 2, 2, 0, 0
		G: T.B 0, 2, 2, 2
		H: T.B 2, 0, 2, 2
		I: T.B 2, 2, 0, 2
		J: T.B 2, 2, 2, 0
		K: T.B 2, 2, 2, 2
		L: "╻"
		M: "╹"
		N: "╸"
		O: "╺"
	double:
		A: T.B 3, 0, 0, 3
		B: T.B 0, 3, 0, 3
		C: T.B 3, 0, 3, 0
		D: T.B 0, 3, 3, 0
		E: T.B 0, 0, 3, 3
		F: T.B 3, 3, 0, 0
		G: T.B 0, 3, 3, 3
		H: T.B 3, 0, 3, 3
		I: T.B 3, 3, 0, 3
		J: T.B 3, 3, 3, 0
		K: T.B 3, 3, 3, 3
		L: "╻"
		M: "╹"
		N: "╸"
		O: "╺"
	block:
		A: "█"
		B: "█"
		C: "█"
		D: "█"
		E: "█"
		F: "█"
		G: "█"
		H: "█"
		I: "█"
		J: "█"
		K: "█"
		L: "█"
		M: "█"
		N: "█"
		O: "█"

font =
	A:"""
-------
--BFA--
-BC-DA-
-GFFFH-
-E---E-
-M---M-
-------
"""
	a:"""
-------
-------
-------
-BFFA--
-E--E--
-DFFJC-
-------
"""
	B: """
-------
-BFFA--
-E--DA-
-GFFFH-
-E--BC-
-DFFC--
-------
"""
	b: """
-------
-L-----
-E-----
-GFFA--
-E--E--
-DFFC--
-------
"""
	C:"""
-------
-BFFFN-
-E-----
-E-----
-E-----
-DFFFN-
-------
"""
	D: """
-------
-BFFA--
-E--DA-
-E---E-
-E--BC-
-DFFC--
-------
"""
	E: """
-------
-BFFFN-
-E-----
-GFFN--
-E-----
-DFFFN-
-------
"""
	F: """
-------
-BFFFN-
-E-----
-GFFN--
-E-----
-M-----
-------
"""
	G: """
-------
-BFFFN-
-E-----
-E-FFA-
-E---E-
-DFFFC-
-------
"""
	H: """
-------
-L---L-
-E---E-
-GFFFH-
-E---E-
-M---M-
-------
"""
	I: """
-------
-OFIFN-
---E---
---E---
---E---
-OFJFN-
-------
"""
	J: """
-------
-FFIFF-
---E---
---E---
-E-E---
-DFC---
-------
"""
	K: """
-------
-L---L-
-E--BC-
-GFFH--
-E--DA-
-M---M-
-------
"""
	L: """
-------
-L-----
-E-----
-E-----
-E-----
-DFFFN-
-------
"""
	M: """
-------
-BFIFA-
BC-E-DA
E--E--E
E-----E
M-----M
-------
"""
	N: """
-------
-BA---L-
-EDA--E-
-E-DA-E-
-E--DAE-
-M---DC-
-------
"""
	O: """
-------
-BFFFA-
-E---E-
-E---E-
-E---E-
-DFFFC-
-------
"""
	P: """
-------
-BFFFA-
-E---E-
-GFFFC-
-E-----
-M-----
-------
"""
	Q: """
-------
-BFFFA-
-E---E-
-E---E-
-DFIFC-
---DFF-
-------
"""
	R:"""
-------
-BFFFA-
-E--BC-
-GFFH--
-E--DA-
-M---M-
-------
"""
	S: """
-------
-BFFFN-
-E-----
-DFFFA-
-----E-
-OFFFC-
-------
"""
	T: """
-------
-OFIFN-
---E---
---E---
---E---
---M---
-------
"""
	U: """
-------
-L---L-
-E---E-
-E---E-
-E---E-
-DFFFC-
-------
"""
	V: """
-------
-L---L-
-E---E-
-E---E-
-DA-BC-
--DFC--
-------
"""
	W: """
-------
L-----L
E-----E
E--E--E
DA-E-BC
-DFJFC-
-------
"""
	X:"""
-------
-L---L-
-DA-BC-
--GFH--
-BC-DA-
-M---M-
-------
"""
	Y:"""
-------
-L---L-
-DA-BC-
--DIC--
---E---
---M---
-------
"""
	Z:"""
-------
-FFFFA-
----BC-
--BFC--
-BC----
-DFFFF-
-------
"""
	0: """
-------
BFFFFIA
E-- BCE
E-BFC-E
EBC---E
DJFFFFC
-------
"""
	1:"""
-------
-BFFA--
-M--E--
----E--
----E--
-FFFJFF
-------
"""
	2:"""
-------
BFFFFFA
M----BC
-BFFFC-
BC----L
DFFFFFC
-------
"""
	3:"""
-------
OFFFFFA
------E
-OFFFFH
------E
OFFFFFC
-------
"""
	4:"""
-------
L---L--
E---E--
DFFFKN-
----E--
----M--
-------
"""
	5: """
-------
BFFFFFA
E-----M
DFFFFFA
L-----E
DFFFFFC
-------
"""
	6: """
-------
BFFFFFA
E-----M
GFFFFFA
E-----E
DFFFFFC
-------
"""
	7:"""
-------
BFFFFFA
M----BC
----BC-
---BC--
--FJF--
-------
"""
	8:"""
-------
BFFFFFA
E-----E
GFFFFFH
E-----E
DFFFFFC
-------
"""
	9:"""
-------
BFFFFFA
E-----E
DFFFFFH
------E
------M
-------
"""
	":": """
-------
--BFA--
--DFC--
-------
--BFA--
--DFC--
-------
"""
	";":"""
-------
--BFA--
--DFC--
--BFA--
--DFH--
--OFC--
-------
"""
	"!": """
-------
---L---
---E---
---E---
-------
---M---
-------
"""
	" ": """
---
---
---
---
---
---
---
"""
	"(":"""
--BFFF-
-BC----
BC-----
E------
DA-----
-DA----
--DFFF-
"""
	")":"""
-FFFA--
----DA-
-----DA
------E
-----BC
----BC-
-FFFC--
"""
	"[":"""
-BFFFF-
-E-----
-E-----
-E-----
-E-----
-E-----
-DFFFF-
"""
	"]":"""
-FFFFA-
-----E-
-----E-
-----E-
-----E-
-----E-
-FFFFC-
"""
	"{":"""
BFFFFN-
E------
DA-----
-E-----
BC-----
E------
DFFFFN-
"""
	"}":"""
-OFFFFA
------E
-----BC
-----E-
-----DA
------E
-OFFFFC
"""
	"+":"""
-------
---L---
---E---
FFFKFFF
---E---
---M---
-------
"""
	"-":"""
-------
-------
-------
FFFFFFF
-------
-------
-------
"""
	"_":"""
-------
-------
-------
-------
-------
FFFFFFF
-------
"""
	"@":"""
-------
BFFFFFA
E-BFA-E
E-E-E-E
E-DFJFC
DFFFFFF
-------
"""
	",":"""
-------
-------
-------
--BFA--
--DFH--
--OFC--
-------
"""
	".":"""
-------
-------
-------
-------
--BFA--
--DFC--
-------
"""
	"?":"""
-------
BFFFFFA
---BFFC
---E--
--BFA--
--DFC--
-------
"""
	"#":"""
-------
-L---L-
FKFFFKF
-E---E-
FKFFFKF
-M---M-
-------
"""
	"=":"""
-------
-------
OFFFFFN
-------
OFFFFFN
-------
-------
"""
	"'":"""
-------
--BFA--
--DFH--
--OFC--
-------
-------
-------
"""
	"`":"""
--BFA--
--DIH--
---DJC-
-------
-------
-------
-------
"""
	"~":"""
-------
-------
BFFA--L
M--DFFC
-------
-------
-------
"""
	"\"":"""
-------
BFA-BFA
DFH-DFH
OFC-OFC
-------
-------
-------
"""
	"$": """
-------
BFFKFFN
E--E---
DFFKFFA
---E--E
OFFKFFC
-------
"""
	"%":"""
-------
-----L-
BA--BC-
DCBFCBA
-BC--DC
-M-----
-------
"""
	"^":"""
-------
--BFA--
-BC-DA-
BC---DA
-------
-------
-------
"""
	"&":"""
-------
-BFFA--
-DA-E--
BFJIC--
E--DKA-
DFFFCM-
-------
"""
	"*":"""
-------
-L-L-L-
-DAEBC-
FFKKKFF
-BCEDA-
-M-M-M-
-------
"""
	"/":"""
-------
-----L-
----BC-
--BFC--
-BC----
-M-----
-------
"""
	"\\":"""
-------
-L-----
-DA----
--DFA--
----DA-
-----M-
-------
"""
	"<":"""
-------
---BF--
-BFC---
OH-----
-DFA---
---DF--
-------
"""
	">":"""
-------
--FA---
---DFA-
-----GN
---BFC-
--FC---
-------
"""
	"|":"""
---L---
---E---
---E---
---E---
---E---
---E---
---M---
"""

for letter, stencil of font
	font[letter] = stencil.split "\n"

module.exports = 
	convert: (words, type = "thin") -> 
		result = ["","","","","","",""]
		for letter in words.split ""
			if stencil = font[letter]
				for chars, line in stencil
					result[line] += chars
			else
				throw "#{letter} Not found"

		result = result.join("\n").replace(/\-/g, " ")

		for sym, char of Chars[type]
			result = result.replace (new RegExp sym, "g"), char
		result

console.log module.exports.convert "ab"
console.log module.exports.convert "ABCDEFGHIJKLMNOP"
console.log module.exports.convert "QRSTUVWXYZ[]<>`~|"
console.log module.exports.convert "0123456789{},.:;?"
console.log module.exports.convert "!@#$%^&*()-_+=\\/"
console.log module.exports.convert "PETS[CAT].GROW()"
console.log module.exports.convert "[X|+ X X]"
