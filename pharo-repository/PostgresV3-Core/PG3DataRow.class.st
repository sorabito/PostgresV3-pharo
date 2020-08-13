Class {
	#name : #PG3DataRow,
	#superclass : #PG3TypedMessage,
	#instVars : [
		'values'
	],
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3DataRow >> isResponse [

	^true
]

{ #category : #'initialize-release' }
PG3DataRow >> readFrom: stream [

	| converters |
	values := connection currentRowClass new: stream nextInt16.
	converters := connection currentConverterSelectors.
	1 to: values size do: [ :index |
		| valueLength |
		values at: index put: (
			(valueLength := stream nextInt32) = -1
				ifTrue: [ nil ]
				ifFalse: [ stream perform: (converters at: index) with: valueLength ]) ]
	
]

{ #category : #accessing }
PG3DataRow >> typeByte [

	^68 "$D asciiValue"
]

{ #category : #accessing }
PG3DataRow >> values [

	^values
]
