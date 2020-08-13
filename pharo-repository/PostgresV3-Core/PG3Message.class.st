"
Message formats are well described in the official PostreSQL Documentation:
http://www.postgresql.org/docs/9.4/static/protocol-message-formats.html
"
Class {
	#name : #PG3Message,
	#superclass : #Object,
	#instVars : [
		'connection'
	],
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #accessing }
PG3Message >> connection [

	^connection
]

{ #category : #accessing }
PG3Message >> connection: aPG3Connection [

	connection := aPG3Connection
]

{ #category : #writing }
PG3Message >> writeByte: anInteger on: aStream [

	aStream nextPut: anInteger
	
]

{ #category : #writing }
PG3Message >> writeCharacter: aCharacter on: aStream [

	aStream nextPut: aCharacter asciiValue
	
]

{ #category : #writing }
PG3Message >> writeDataOn: aStream [
]

{ #category : #writing }
PG3Message >> writeInt32: anInteger on: aStream [

	aStream
		nextPut: ((anInteger bitShift: -24) bitAnd: 255);
		nextPut: ((anInteger bitShift: -16) bitAnd: 255);
		nextPut: ((anInteger bitShift: -8) bitAnd: 255);
		nextPut: (anInteger bitAnd: 255)
		
		
]

{ #category : #writing }
PG3Message >> writeOn: aStream [
	"Leave place for the length, write the message, then fill the length."

	| lengthPosition endPosition |
	lengthPosition := aStream position.
	aStream skip: 4.
	self writeDataOn: aStream.
	endPosition := aStream position.
	aStream position: lengthPosition.
	self writeInt32: endPosition - lengthPosition on: aStream.
	aStream position: endPosition
	
]

{ #category : #writing }
PG3Message >> writeString: aByteString on: aStream [

	1 to: aByteString size do: [ :index |
		aStream nextPut: (aByteString at: index) asciiValue ].
	aStream nextPut: 0
	
]
