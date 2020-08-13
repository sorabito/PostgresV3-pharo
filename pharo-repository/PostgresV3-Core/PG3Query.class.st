"
Send a query using the ""simple query"" protocol. 
The query string is directly sent to PostgreSQL without any further processing.
"
Class {
	#name : #PG3Query,
	#superclass : #PG3TypedMessage,
	#instVars : [
		'queryString'
	],
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3Query >> isRequest [

	^true
]

{ #category : #accessing }
PG3Query >> queryString: aByteString [

	queryString := aByteString
]

{ #category : #accessing }
PG3Query >> typeByte [

	^81 "$Q asciiValue"
]

{ #category : #writing }
PG3Query >> writeDataOn: aStream [

	self writeString: queryString on: aStream
]
