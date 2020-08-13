Class {
	#name : #PG3CommandComplete,
	#superclass : #PG3TypedMessage,
	#instVars : [
		'commandTag'
	],
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #accessing }
PG3CommandComplete >> commandTag [

	^commandTag
]

{ #category : #testing }
PG3CommandComplete >> isResponse [

	^true
]

{ #category : #'initialize-release' }
PG3CommandComplete >> readFrom: stream [

	commandTag := stream nextString
]

{ #category : #accessing }
PG3CommandComplete >> typeByte [

	^67 "$C asciiValue"
]
