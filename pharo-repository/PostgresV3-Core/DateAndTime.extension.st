Extension { #name : #DateAndTime }

{ #category : #'*PostgresV3-Core' }
DateAndTime >> pg3PrintAsLiteralOn: stream [

	stream
		nextPutAll: 'timestamp ''';
		print: self;
		nextPut: $'
]
