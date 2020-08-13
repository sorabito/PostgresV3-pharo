"
When receiving this message, the frontend must now send a PasswordMessage containing the password in clear-text form. If this is the correct password, the server responds with an AuthenticationOk, otherwise it responds with an ErrorResponse.

"
Class {
	#name : #PG3AuthenticationCleartextPassword,
	#superclass : #PG3AuthenticationMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #accessing }
PG3AuthenticationCleartextPassword class >> subType [

	^3
]

{ #category : #'initialize-release' }
PG3AuthenticationCleartextPassword >> readFrom: stream [
]
