Class {
	#name : #PG3StartupMessage,
	#superclass : #PG3Message,
	#instVars : [
		'parameters'
	],
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #'instance creation' }
PG3StartupMessage class >> for: connection [

	| arguments |
	arguments := connection arguments.
	^self new
		addParameter: 'user' value: arguments username;
		addParameter: 'database' value: arguments databaseName;
		yourself
]

{ #category : #accessing }
PG3StartupMessage >> addParameter: parameterString value: valueString [

	parameters add: parameterString -> valueString
]

{ #category : #initialization }
PG3StartupMessage >> initialize [

	parameters := OrderedCollection new.
	self initializeParameters 
]

{ #category : #initialization }
PG3StartupMessage >> initializeParameters [
]

{ #category : #writing }
PG3StartupMessage >> writeDataOn: aStream [

	self writeInt32: 196608 on: aStream. "Protocol version #(0 3 0 0)"
	parameters do: [ :each |
		self 
			writeString: each key on: aStream;
			writeString: each value on: aStream ].
	self writeByte: 0 on: aStream "Packet terminator"
]
