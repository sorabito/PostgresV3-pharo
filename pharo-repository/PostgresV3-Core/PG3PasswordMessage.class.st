Class {
	#name : #PG3PasswordMessage,
	#superclass : #PG3TypedMessage,
	#instVars : [
		'password'
	],
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3PasswordMessage >> isRequest [

	^true
]

{ #category : #accessing }
PG3PasswordMessage >> password: aString [

	password := aString	

	
]

{ #category : #accessing }
PG3PasswordMessage >> typeByte [

	^112 "$p asciiValue"
]

{ #category : #writing }
PG3PasswordMessage >> writeDataOn: aStream [

	self writeString: password on: aStream
]
