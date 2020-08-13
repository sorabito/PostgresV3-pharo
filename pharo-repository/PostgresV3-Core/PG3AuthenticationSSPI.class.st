"
The frontend must now initiate a SSPI negotiation. The frontend will send a PasswordMessage with the first part of the SSPI data stream in response to this. If further messages are needed, the server will respond with AuthenticationGSSContinue.

"
Class {
	#name : #PG3AuthenticationSSPI,
	#superclass : #PG3AuthenticationMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #accessing }
PG3AuthenticationSSPI class >> subType [

	^9
]
