"
See PG3CloseComplete
"
Class {
	#name : #PG3CloseComplete,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3CloseComplete >> isResponse [

	^true
]

{ #category : #accessing }
PG3CloseComplete >> typeByte [

	^51 "$3 asciiValue"
]
