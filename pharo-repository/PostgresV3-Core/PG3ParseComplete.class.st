"
Part to flow for extended queries:
Parse -> Bind -> Execute
"
Class {
	#name : #PG3ParseComplete,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3ParseComplete >> isResponse [

	^true
]

{ #category : #accessing }
PG3ParseComplete >> typeByte [

	^49 "$1 asciiValue"
]
