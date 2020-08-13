Extension { #name : #String }

{ #category : #'*PostgresV3-Core' }
String >> asPG3SqlIdentifier [

	^String streamContents: [ :stream |
		stream nextPut: $".
		self do: [ :each |
			(#($" $\) includes: each) ifTrue: [
				stream nextPut: each ].
			stream nextPut: each ].
		stream nextPut: $" ]
]

{ #category : #'*PostgresV3-Core' }
String >> pg3PrintAsLiteralOn: stream [

	self storeOn: stream
]
