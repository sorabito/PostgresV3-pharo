parsing
parseInfinityLength: length onSuccessDo: aBlock
	| currentPosition result |
	(self hasInfinityLength: length) ifFalse: [ ^ self ].

	currentPosition := self position.
	result := self parseStringLength: length.
	(result = 'infinity' or: [ result = '-infinity' ])
		ifFalse: [ self position: currentPosition ]
		ifTrue: [
			self position: currentPosition + length.
			aBlock value: (result = 'infinity'
				ifTrue: [ aBlock value: InfiniteFuture new ]
				ifFalse: [ InfinitePast new ]) ]