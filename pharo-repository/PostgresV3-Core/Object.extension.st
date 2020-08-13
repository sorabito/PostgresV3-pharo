Extension { #name : #Object }

{ #category : #'*PostgresV3-Core' }
Object >> asPG3SqlLiteral [

	^String streamContents: [ :stream |
		self pg3PrintAsLiteralOn: stream ]
]

{ #category : #'*PostgresV3-Core' }
Object >> pg3PrintAsLiteralOn: stream [

	self printOn: stream
]
