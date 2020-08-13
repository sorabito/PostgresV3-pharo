Class {
	#name : #PG3TypedMessage,
	#superclass : #PG3Message,
	#instVars : [
		'length'
	],
	#classVars : [
		'DispatcherArray'
	],
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #dispatching }
PG3TypedMessage class >> dispatchFrom: stream connection: connection [

	^(DispatcherArray at: stream next) readFrom: stream connection: connection
]

{ #category : #initialization }
PG3TypedMessage class >> initialize [

	super initialize.
	self initializeDispatcherArray 
]

{ #category : #initialization }
PG3TypedMessage class >> initializeDispatcherArray [
	" self initializeDispatcherArray "

	DispatcherArray := Array new: 256.
	self allSubclassesDo: [ :subclass |
		subclass basicNew in: [ :instance |
			((subclass methodDictionary includesKey: #typeByte) and: [ 
				instance isResponse ]) ifTrue: [
					DispatcherArray at: instance typeByte put: subclass ] ] ]
]

{ #category : #'instance creation' }
PG3TypedMessage class >> readFrom: stream [

	^self new
		length: stream nextInt32 - 4;
		readFrom: stream;
		yourself
]

{ #category : #'instance creation' }
PG3TypedMessage class >> readFrom: stream connection: connection [

	^self new
		connection: connection;
		length: stream nextInt32 - 4;
		readFrom: stream;
		yourself
]

{ #category : #testing }
PG3TypedMessage >> isRequest [

	^false
]

{ #category : #testing }
PG3TypedMessage >> isResponse [

	^false
]

{ #category : #accessing }
PG3TypedMessage >> length: anInteger [

	length := anInteger
]

{ #category : #'initialize-release' }
PG3TypedMessage >> readFrom: stream [

	self subclassResponsibility
]

{ #category : #accessing }
PG3TypedMessage >> typeByte [

	self subclassResponsibility
]

{ #category : #writing }
PG3TypedMessage >> writeOn: aStream [

	self writeByte: self typeByte on: aStream.
	super writeOn: aStream
]
