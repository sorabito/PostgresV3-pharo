"
The frontend must now initiate a GSSAPI negotiation. The frontend will send a PasswordMessage with the first part of the GSSAPI data stream in response to this. If further messages are needed, the server will respond with AuthenticationGSSContinue.

"
Class {
	#name : #PG3AuthenticationGSS,
	#superclass : #PG3AuthenticationMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #accessing }
PG3AuthenticationGSS class >> subType [

	^7
]
