"
Sent by the server after a successful authentication (See  PG3AuthenticationOkMessage).

This message provides secret-key data that the frontend must save if it wants to be able to issue cancel requests later. The frontend should not respond to this message, but should continue listening for a ReadyForQuery message.

"
Class {
	#name : #PG3BackendKeyData,
	#superclass : #PG3TypedMessage,
	#instVars : [
		'processId',
		'secretKey'
	],
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3BackendKeyData >> isResponse [

	^true
]

{ #category : #accessing }
PG3BackendKeyData >> processId [

	^processId
]

{ #category : #'initialize-release' }
PG3BackendKeyData >> readFrom: stream [
	
	processId := stream nextInt32.
	secretKey := stream nextInt32
]

{ #category : #accessing }
PG3BackendKeyData >> secretKey [

	^secretKey
]

{ #category : #accessing }
PG3BackendKeyData >> typeByte [

	^75 "$K asciiValue"
]
