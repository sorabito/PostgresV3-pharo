Class {
	#name : #PG3ListenerConnection,
	#superclass : #PG3Connection,
	#instVars : [
		'listenerProcess',
		'actions'
	],
	#category : #'PostgresV3-Core'
}

{ #category : #'listen-notify-subprotocol' }
PG3ListenerConnection >> createListenerProcess [

	listenerProcess ifNotNil: [ 
		^self ].
	listenerProcess := [ self listenerProcess ] newProcess.
	listenerProcess resume
]

{ #category : #'simple-query-protocol' }
PG3ListenerConnection >> execute: aString [

	self error: 'This connection can not execute queries'
]

{ #category : #'listen-notify-subprotocol' }
PG3ListenerConnection >> killListenerProcess [ 

	listenerProcess ifNotNil: [
		listenerProcess terminate.
		listenerProcess := nil ]
]

{ #category : #'listen-notify-subprotocol' }
PG3ListenerConnection >> listen: aString do: aValueable [
	
	self killListenerProcess.
	super execute: 'listen ', aString asPG3SqlIdentifier.
	actions at: aString put: aValueable.
	self createListenerProcess
]

{ #category : #'listen-notify-subprotocol' }
PG3ListenerConnection >> listenerProcess [

	[ 
		| message |
		message := self receiveMessage.
		state := state receive: message from: self ] repeat
]

{ #category : #'listen-notify-subprotocol' }
PG3ListenerConnection >> receiveNotification: aPG3NotificationResponse [

	(actions at: aPG3NotificationResponse conditionName ifAbsent: [ ^self ])
		cull: aPG3NotificationResponse payload
]

{ #category : #'startup-protocol' }
PG3ListenerConnection >> startup [ 

	actions := Dictionary new.
	super startup
	
]

{ #category : #actions }
PG3ListenerConnection >> terminate [

	self killListenerProcess.
	super terminate
]

{ #category : #'listen-notify-subprotocol' }
PG3ListenerConnection >> unlisten: aString [

	(actions includesKey: aString) ifFalse: [
		^self ].
	self killListenerProcess.
	super execute: 'unlisten ', aString.
	actions removeKey: aString.
	actions ifNotEmpty: [ self createListenerProcess ]
]
