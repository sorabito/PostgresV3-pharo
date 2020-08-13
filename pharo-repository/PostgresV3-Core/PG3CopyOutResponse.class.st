Class {
	#name : #PG3CopyOutResponse,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3CopyOutResponse >> isResponse [

	^true
]

{ #category : #accessing }
PG3CopyOutResponse >> typeByte [

	^72 "$H asciiValue"
]
