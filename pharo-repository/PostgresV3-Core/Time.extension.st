Extension { #name : #Time }

{ #category : #'*PostgresV3-Core' }
Time >> pg3PrintAsLiteralOn: stream [

	stream nextPut: $'.
	self print24: true showSeconds: true on: stream.
	stream nextPut: $'
]
