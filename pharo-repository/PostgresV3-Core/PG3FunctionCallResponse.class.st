"
The function call was completed and returned the result given in the message. (Note that the Function Call protocol can only handle a single scalar result, not a row type or set of results.)
"
Class {
	#name : #PG3FunctionCallResponse,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3FunctionCallResponse >> isResponse [

	^true
]

{ #category : #accessing }
PG3FunctionCallResponse >> typeByte [

	^86 "$V asciiValue"
]
