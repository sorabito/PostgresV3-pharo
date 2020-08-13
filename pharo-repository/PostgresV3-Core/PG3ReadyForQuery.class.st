"
The ReadyForQuery message is the same one that the backend will issue after each command cycle. Depending on the coding needs of the frontend, it is reasonable to consider ReadyForQuery as starting a command cycle, or to consider ReadyForQuery as ending the start-up phase and each subsequent command cycle.
"
Class {
	#name : #PG3ReadyForQuery,
	#superclass : #PG3TypedMessage,
	#instVars : [
		'transactionState'
	],
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3ReadyForQuery >> isResponse [

	^true
]

{ #category : #'initialize-release' }
PG3ReadyForQuery >> readFrom: stream [

	transactionState := stream next
]

{ #category : #accessing }
PG3ReadyForQuery >> transactionState [

	^transactionState
]

{ #category : #accessing }
PG3ReadyForQuery >> typeByte [

	^90 "$Z asciiValue"
]
