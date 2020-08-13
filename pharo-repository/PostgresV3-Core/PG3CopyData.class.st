Class {
	#name : #PG3CopyData,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3CopyData >> isRequest [

	^true
]

{ #category : #testing }
PG3CopyData >> isResponse [

	^true
]

{ #category : #accessing }
PG3CopyData >> typeByte [

	^100 "$d asciiValue"
]
