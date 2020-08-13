Class {
	#name : #PG3NoData,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3NoData >> isResponse [

	^true
]

{ #category : #accessing }
PG3NoData >> typeByte [

	^110 "$n asciiValue"
]
