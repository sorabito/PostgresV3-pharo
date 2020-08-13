Class {
	#name : #PG3CopyInResponse,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3CopyInResponse >> isResponse [

	^true
]

{ #category : #accessing }
PG3CopyInResponse >> typeByte [

	^71 "$G asciiValue"
]
