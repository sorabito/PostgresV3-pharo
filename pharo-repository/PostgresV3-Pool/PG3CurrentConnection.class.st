Class {
	#name : #PG3CurrentConnection,
	#superclass : #Notification,
	#instVars : [
		'pool'
	],
	#category : #'PostgresV3-Pool'
}

{ #category : #'instance creation' }
PG3CurrentConnection class >> signalFor: aPG3ConnectionPool [

	^self new
		pool: aPG3ConnectionPool;
		signal	
]

{ #category : #accessing }
PG3CurrentConnection >> pool [

	^pool
]

{ #category : #accessing }
PG3CurrentConnection >> pool: aPG3ConnectionPool [

	pool := aPG3ConnectionPool
]
