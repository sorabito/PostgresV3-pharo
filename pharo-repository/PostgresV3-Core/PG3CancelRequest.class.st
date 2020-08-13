Class {
	#name : #PG3CancelRequest,
	#superclass : #PG3Message,
	#instVars : [
		'processId',
		'secretKey'
	],
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #'instance creation' }
PG3CancelRequest class >> for: aPG3Connection [

	^self new
		processId: aPG3Connection processId;
		secretKey: aPG3Connection secretKey;
		yourself
]

{ #category : #accessing }
PG3CancelRequest >> processId: anInteger [

	processId := anInteger
]

{ #category : #accessing }
PG3CancelRequest >> secretKey: anInteger [

	secretKey := anInteger
]

{ #category : #writing }
PG3CancelRequest >> writeDataOn: aStream [

	self 
		writeInt32: 80877102 on: aStream; "1234 5678"
		writeInt32: processId on: aStream;
		writeInt32: secretKey on: aStream
	
]
