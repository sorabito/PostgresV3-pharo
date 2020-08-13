"
Part to flow for extended queries:
Parse -> Bind -> Execute
"
Class {
	#name : #PG3BindComplete,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3BindComplete >> isResponse [

	^true
]

{ #category : #accessing }
PG3BindComplete >> typeByte [

	^50 "$2 asciiValue"
]
