accessing
peekUpTo: anInteger
	| next originalPosition result |
	originalPosition := position.
	result := OrderedCollection new: 5.
	[ position = readLimit or: [ (next := self next) = anInteger ] ] whileFalse: [
		result add: next ].
	self position: originalPosition.
	^ result