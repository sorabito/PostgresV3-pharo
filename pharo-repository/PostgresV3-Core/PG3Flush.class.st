Class {
	#name : #PG3Flush,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3Flush >> isRequest [

	^true
]

{ #category : #accessing }
PG3Flush >> typeByte [

	^72 "$H asciiValue"
]
