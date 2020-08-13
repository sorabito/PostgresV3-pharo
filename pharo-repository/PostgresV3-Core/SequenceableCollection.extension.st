Extension { #name : #SequenceableCollection }

{ #category : #'*PostgresV3-Core' }
SequenceableCollection >> pg3PrintAsLiteralOn: stream [

	self ifEmpty: [ ^stream nextPutAll: '''{}''' ].
	stream nextPutAll: 'array['.
	self 
		do: [ :each | each pg3PrintAsLiteralOn: stream ]
		separatedBy: [ stream nextPutAll: ', ' ].
	stream nextPut: $]
]
