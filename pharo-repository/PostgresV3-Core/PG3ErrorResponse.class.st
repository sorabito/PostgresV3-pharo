Class {
	#name : #PG3ErrorResponse,
	#superclass : #PG3ExceptionResponse,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #accessing }
PG3ErrorResponse >> typeByte [

	^69 "$E asciiValue"
]
