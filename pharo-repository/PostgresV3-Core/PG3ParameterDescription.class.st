Class {
	#name : #PG3ParameterDescription,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3ParameterDescription >> isResponse [

	^true
]

{ #category : #accessing }
PG3ParameterDescription >> typeByte [

	^116 "$t asciiValue"
]
