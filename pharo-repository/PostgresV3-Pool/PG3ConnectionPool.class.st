"
Usage:

A connection pool is a singleton, so create a subclass of
PG3ConnectionPool:

PG3ConnectionPool subclass: #PG3ExampleConnectionPool
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Postgres-Example'

Implement #defaultConnectionArguments on the class side:

defaultConnectionArguments
	^PG3ConnectionArguments new
		hostname: '127.0.0.1';
		port: 5432;
		username: 'user1';
		password: '123';
		databaseName: 'foo';
		yourself.

Then you can use your connection pool using the following;

PG3ExampleConnectionPool default withConnectionDo: [ :connection |
	connection execute: 'select 3 + 4'.
	connection execute: 'select now()' ]. 
"
Class {
	#name : #PG3ConnectionPool,
	#superclass : #Object,
	#instVars : [
		'monitor',
		'freeConnections',
		'usedConnections',
		'connectionArguments',
		'arguments'
	],
	#classVars : [
		'Instance'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'PostgresV3-Pool'
}

{ #category : #'as yet unclassified' }
PG3ConnectionPool class >> default [

	^instance ifNil: [
		instance := self new
			connectionArguments: self defaultConnectionArguments;
			yourself ]
]

{ #category : #'as yet unclassified' }
PG3ConnectionPool class >> defaultConnectionArguments [
	
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PG3ConnectionPool class >> reset [

	instance := nil
]

{ #category : #'as yet unclassified' }
PG3ConnectionPool class >> startUp: resuming [

	resuming ifTrue: [ 
		self reset ]
]

{ #category : #accessing }
PG3ConnectionPool >> connectionArguments [

	^connectionArguments
]

{ #category : #accessing }
PG3ConnectionPool >> connectionArguments: aPG3ConnectionArguments [ 

	connectionArguments := aPG3ConnectionArguments
]

{ #category : #private }
PG3ConnectionPool >> createNewConnection [
	
	^PG3Connection new
		arguments: connectionArguments;
		startup;
		yourself
]

{ #category : #accessing }
PG3ConnectionPool >> currentConnections [

	^monitor critical: [
		usedConnections size + freeConnections size ]
]

{ #category : #'query execution' }
PG3ConnectionPool >> executeQuery: queryString [

	^self executeQuery: queryString rowClass: nil
]

{ #category : #'query execution' }
PG3ConnectionPool >> executeQuery: queryString rowClass: aClass [

	| currentConnection |
	currentConnection := PG3CurrentConnection signalFor: self.
	^currentConnection 
		ifNil: [ 
			self withConnectionDo: [ :conn |
				conn execute: queryString rowClass: aClass ] ]
		ifNotNil: [
			currentConnection execute: queryString rowClass: aClass ]
]

{ #category : #'query execution' }
PG3ConnectionPool >> executeTransaction: aBlock [

	(PG3CurrentConnection signalFor: self) ifNotNil: [ :connection |
		"We're already in a transaction"
		^aBlock cull: connection ].
	^self withConnectionDo: [ :connection |
		[
			| result |
			connection execute: 'begin'.
			result := [ aBlock cull: connection ]
				on: PG3CurrentConnection 
				do: [ :not | 
					not pool == self
						ifTrue: [ not resume: connection ]
						ifFalse: [ not pass ] ].
			connection isInTransaction ifTrue: [
				connection execute: 'commit' ].
			result ]
				ensure: [ 
					connection ifNotNil: [
						connection isIdle ifFalse: [
							connection execute: 'rollback' ] ] ] ]
]

{ #category : #accessing }
PG3ConnectionPool >> freeConnections [

	^monitor critical: [ freeConnections size ]
]

{ #category : #private }
PG3ConnectionPool >> getConnection [
	
	| freeConnection timeout |
	freeConnection := nil.
	timeout := DateAndTime now + arguments waitTimeout milliSeconds.
	monitor critical: [
		self log: [ 'FreeConnections: ', freeConnections size asString, String cr, 'UsedConnections: ', usedConnections size asString ].
		[ DateAndTime now < timeout and: [ freeConnection isNil ] ] whileTrue: [
			freeConnections 
				ifNotEmpty: [ freeConnection := freeConnections removeLast ]
				ifEmpty: [
					monitor
						waitUntil: [
							DateAndTime now >= timeout 
								or: [ freeConnections notEmpty 
								or: [ usedConnections size < arguments maxConnections ] ] ]
						maxMilliseconds: (timeout - DateAndTime now) asMilliSeconds.
					(freeConnections isEmpty and: [
						usedConnections size < arguments maxConnections ]) ifTrue: [
							[ freeConnection := self createNewConnection ]
								on: Error
								do: [ :error | self log: error messageText ] ] ].
			(freeConnection notNil and: [ 
				freeConnection isConnected and: [
					freeConnection isReadyForQuery ] ])
				ifFalse: [ freeConnection := nil ] ].
		freeConnection ifNotNil: [ usedConnections add: freeConnection ] ].
	^freeConnection ifNil: [ 
		self error: 'Couldn''t get a connection in ', arguments waitTimeout asString, ' milliseconds!'.
		freeConnection ]
]

{ #category : #'initialize-release' }
PG3ConnectionPool >> initialize [

	freeConnections := OrderedCollection new.
	usedConnections := OrderedCollection new.
	monitor := Monitor new.
	arguments := PG3ConnectionPoolArguments new
]

{ #category : #private }
PG3ConnectionPool >> log: aStringOrBlock [
	"Subclasses can hook their own logging mechanism here."
]

{ #category : #accessing }
PG3ConnectionPool >> newListenerConnection [

	^PG3ListenerConnection new
		arguments: connectionArguments;
		startup;
		yourself	
]

{ #category : #private }
PG3ConnectionPool >> releaseAllFreeConnections [
	
	monitor critical: [
		[ freeConnections size > 0 ] whileTrue: [
			| connection |
			connection := freeConnections removeFirst.
			connection isConnected ifTrue: [ connection terminate ].
			self log: 'Connection removed from the pool.' ] ]
]

{ #category : #private }
PG3ConnectionPool >> releaseConnection: aPG3Connection [
	
	| invalidConnection |
	aPG3Connection isInTransaction ifTrue: [ 
		aPG3Connection cancelRequest ].
	invalidConnection := false.
	monitor critical: [	
		(usedConnections remove: aPG3Connection ifAbsent: nil)
			ifNil: [ invalidConnection := true ]
			ifNotNil: [
				aPG3Connection isIdle ifTrue: [ 
					freeConnections add: aPG3Connection ].
				self releaseSuperfluousFreeConnections.
				freeConnections ifNotEmpty: [ monitor signal ] ] ].
	invalidConnection ifTrue: [
		aPG3Connection terminate.
		"self error: 'Tried to release a connection from another pool'" ].
]

{ #category : #private }
PG3ConnectionPool >> releaseSuperfluousFreeConnections [
	
	monitor critical: [
		[ freeConnections size > arguments maxFreeConnections ] whileTrue: [
			| connection |
			connection := freeConnections removeFirst.
			connection isConnected ifTrue: [ connection terminate ].
			self log: 'Connection removed from the pool.' ] ]
]

{ #category : #private }
PG3ConnectionPool >> releaseUsedConnections [
	
	monitor critical: [
		usedConnections copy do: [ :each |
			self releaseConnection: each ] ]
]

{ #category : #accessing }
PG3ConnectionPool >> usedConnections [

	^monitor critical: [ usedConnections size ]
]

{ #category : #accessing }
PG3ConnectionPool >> withConnectionDo: aBlock [
	"aBlock shouldn't have side-effects because of retries"

	| retriesLeft |
	retriesLeft := 3.
	^[ 
		| connection |
		[ 
			connection := self getConnection.
			aBlock value: connection ]
				ensure: [
					connection ifNotNil: [
						 self releaseConnection: connection ] ] ]
		on: ConnectionClosed, ConnectionTimedOut 
		do: [ :err |
			retriesLeft > 0 ifTrue: [
				self log: [ 'Error ', (4 - retriesLeft) asString, ': ', err className, ' -> ', err messageText ].
				retriesLeft := retriesLeft - 1.
				err retry ].
			err pass ]
]
