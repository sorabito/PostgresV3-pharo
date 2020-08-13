Class {
	#name : #PG3ConnectionPoolArguments,
	#superclass : #Object,
	#instVars : [
		'minConnections',
		'maxConnections',
		'waitTimeout',
		'maxFreeConnections'
	],
	#category : #'PostgresV3-Pool'
}

{ #category : #'initialize-release' }
PG3ConnectionPoolArguments >> initialize [

	minConnections := 0.
	maxConnections := 10.
	maxFreeConnections := 10.
	waitTimeout := 2000
]

{ #category : #accessing }
PG3ConnectionPoolArguments >> maxConnections [

	^maxConnections
]

{ #category : #accessing }
PG3ConnectionPoolArguments >> maxConnections: anInteger [

	maxConnections := anInteger
]

{ #category : #accessing }
PG3ConnectionPoolArguments >> maxFreeConnections [

	^maxFreeConnections
]

{ #category : #accessing }
PG3ConnectionPoolArguments >> maxFreeConnections: anInteger [

	maxFreeConnections := anInteger
]

{ #category : #accessing }
PG3ConnectionPoolArguments >> minConnections [

	^minConnections
]

{ #category : #accessing }
PG3ConnectionPoolArguments >> minConnections: anInteger [

	minConnections := anInteger
]

{ #category : #accessing }
PG3ConnectionPoolArguments >> waitTimeout [

	^waitTimeout
]

{ #category : #accessing }
PG3ConnectionPoolArguments >> waitTimeout: anInteger [

	waitTimeout := anInteger
]
