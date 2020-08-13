Class {
	#name : #PG3CopyFail,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3CopyFail >> isRequest [

	^true
]

{ #category : #accessing }
PG3CopyFail >> typeByte [

	^102 "$f asciiValue"
]
