"
Part to flow for extended queries:
Parse -> Bind -> Execute
"
Class {
	#name : #PG3Execute,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3Execute >> isRequest [

	^true
]

{ #category : #accessing }
PG3Execute >> typeByte [

	^69 "$I asciiValue"
]
