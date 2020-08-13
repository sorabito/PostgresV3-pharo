Class {
	#name : #PG3NotificationResponse,
	#superclass : #PG3TypedMessage,
	#instVars : [
		'processId',
		'conditionName',
		'payload'
	],
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #accessing }
PG3NotificationResponse >> conditionName [

	^conditionName 
]

{ #category : #testing }
PG3NotificationResponse >> isResponse [

	^true
]

{ #category : #accessing }
PG3NotificationResponse >> payload [

	^payload
]

{ #category : #accessing }
PG3NotificationResponse >> processId [

	^processId
]

{ #category : #'initialize-release' }
PG3NotificationResponse >> readFrom: stream [

	processId := stream nextInt32.
	conditionName := stream nextString.
	payload := stream nextString
]

{ #category : #accessing }
PG3NotificationResponse >> typeByte [

	^65 "$A asciiValue"
]
