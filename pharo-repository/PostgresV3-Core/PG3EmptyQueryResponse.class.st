Class {
	#name : #PG3EmptyQueryResponse,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3EmptyQueryResponse >> isResponse [

	^true
]

{ #category : #'initialize-release' }
PG3EmptyQueryResponse >> readFrom: stream [
]

{ #category : #accessing }
PG3EmptyQueryResponse >> typeByte [

	^73 "$I asciiValue"
]
