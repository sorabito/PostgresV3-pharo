"
The Close message closes an existing prepared statement or portal and releases resources. It is not an error to issue Close against a nonexistent statement or portal name. The response is normally CloseComplete, but could be ErrorResponse if some difficulty is encountered while releasing resources. Note that closing a prepared statement implicitly closes any open portals that were constructed from that statement.
"
Class {
	#name : #PG3Close,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3Close >> isRequest [

	^true
]

{ #category : #accessing }
PG3Close >> typeByte [

	^67 "$C asciiValue"
]
