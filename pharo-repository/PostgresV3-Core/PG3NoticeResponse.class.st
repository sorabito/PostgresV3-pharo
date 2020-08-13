"
A warning message has been issued. The frontend should display the message .

"
Class {
	#name : #PG3NoticeResponse,
	#superclass : #PG3ExceptionResponse,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #accessing }
PG3NoticeResponse >> typeByte [

	^78 "$N asciiValue"
]
