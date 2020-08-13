Extension { #name : #UndefinedObject }

{ #category : #'*PostgresV3-Core' }
UndefinedObject >> pg3PrintAsLiteralOn: stream [

	stream nextPutAll: 'null'
]
