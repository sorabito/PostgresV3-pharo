"
Send by the server when authentication was successful.

After having received AuthenticationOk, the frontend must wait for further messages from the server. In this phase a backend process is being started, and the frontend is just an interested bystander. It is still possible for the startup attempt to fail (ErrorResponse), but in the normal case the backend will send some ParameterStatus messages, BackendKeyData, and finally ReadyForQuery.
"
Class {
	#name : #PG3AuthenticationOkMessage,
	#superclass : #PG3AuthenticationMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #accessing }
PG3AuthenticationOkMessage class >> subType [

	^0
]

{ #category : #'initialize-release' }
PG3AuthenticationOkMessage >> readFrom: stream [

	
]
