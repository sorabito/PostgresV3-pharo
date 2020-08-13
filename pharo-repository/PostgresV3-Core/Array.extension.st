Extension { #name : #Array }

{ #category : #'*PostgresV3-Core' }
Array >> atOrLast: anInteger [

	<primitive: 60>
	^self at: self size
]
