parsing-private
parseNextArrayElementWithLength: aBlock
	| nextBytes |
	nextBytes := self peekUpTo: 44. "$, asciiValue"
	nextBytes := nextBytes last = 125 "$} asciiValue"
		ifTrue: [ nextBytes allButLast ]
		ifFalse: [ nextBytes ].
	^ aBlock value: nextBytes size