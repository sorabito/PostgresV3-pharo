"
The appearance of this message tells the frontend that another Execute should be issued against the same portal to complete the operation.
"
Class {
	#name : #PG3PortalSuspended,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3PortalSuspended >> isResponse [

	^true
]

{ #category : #accessing }
PG3PortalSuspended >> typeByte [

	^115 "$s asciiValue"
]
