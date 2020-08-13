"
The Function Call sub-protocol allows the client to request a direct call of any function that exists in the database's pg_proc system catalog. The client must have execute permission for the function.
"
Class {
	#name : #PG3FunctionCall,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3FunctionCall >> isRequest [

	^true
]

{ #category : #accessing }
PG3FunctionCall >> typeByte [

	^70 "$F asciiValue"
]
