Class {
	#name : #PG3Terminate,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3Terminate >> isRequest [

	^true
]

{ #category : #accessing }
PG3Terminate >> typeByte [

	^88 "$X asciiValue"
]
