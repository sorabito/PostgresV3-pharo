Class {
	#name : #PG3CopyDone,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3CopyDone >> isRequest [

	^true
]

{ #category : #testing }
PG3CopyDone >> isResponse [

	^true
]

{ #category : #accessing }
PG3CopyDone >> typeByte [

	^99 "$c asciiValue"
]
