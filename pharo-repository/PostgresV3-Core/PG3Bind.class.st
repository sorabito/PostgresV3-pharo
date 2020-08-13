"
Part to flow for extended queries:
Parse -> Bind -> Execute
"
Class {
	#name : #PG3Bind,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3Bind >> isRequest [

	^true
]

{ #category : #accessing }
PG3Bind >> typeByte [

	^66 "$B asciiValue"
]
