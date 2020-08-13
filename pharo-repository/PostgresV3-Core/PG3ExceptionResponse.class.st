Class {
	#name : #PG3ExceptionResponse,
	#superclass : #PG3TypedMessage,
	#instVars : [
		'severity',
		'code',
		'message',
		'detail',
		'hint',
		'position',
		'internalPosition',
		'internalQuery',
		'where',
		'file',
		'routine'
	],
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #accessing }
PG3ExceptionResponse >> code [
	^ code
]

{ #category : #accessing }
PG3ExceptionResponse >> code: anObject [
	^ code := anObject
]

{ #category : #accessing }
PG3ExceptionResponse >> detail [
	^ detail
]

{ #category : #accessing }
PG3ExceptionResponse >> detail: anObject [
	^ detail := anObject
]

{ #category : #accessing }
PG3ExceptionResponse >> file [
	^ file
]

{ #category : #accessing }
PG3ExceptionResponse >> file: anObject [
	^ file := anObject
]

{ #category : #accessing }
PG3ExceptionResponse >> hint [
	^ hint
]

{ #category : #accessing }
PG3ExceptionResponse >> hint: anObject [
	^ hint := anObject
]

{ #category : #accessing }
PG3ExceptionResponse >> internalPosition [
	^ internalPosition
]

{ #category : #accessing }
PG3ExceptionResponse >> internalPosition: anObject [
	^ internalPosition := anObject
]

{ #category : #accessing }
PG3ExceptionResponse >> internalQuery [
	^ internalQuery
]

{ #category : #accessing }
PG3ExceptionResponse >> internalQuery: anObject [
	^ internalQuery := anObject
]

{ #category : #testing }
PG3ExceptionResponse >> isResponse [

	^true
]

{ #category : #accessing }
PG3ExceptionResponse >> message [
	^ message
]

{ #category : #accessing }
PG3ExceptionResponse >> message: anObject [
	^ message := anObject
]

{ #category : #accessing }
PG3ExceptionResponse >> position [
	^ position
]

{ #category : #accessing }
PG3ExceptionResponse >> position: anObject [
	^ position := anObject
]

{ #category : #'initialize-release' }
PG3ExceptionResponse >> readFrom: aStream [

	[
		aStream next
			caseOf: {
				[ 0 ] -> [ ^self ].
				[ $S asciiValue ] -> [ severity := aStream nextString ].
				[ $C asciiValue ] -> [ code := aStream nextString ].
				[ $M asciiValue ] -> [ message := aStream nextString ].
				[ $D asciiValue ] -> [ detail := aStream nextString ].
				[ $H asciiValue ] -> [ hint := aStream nextString ].
				[ $P asciiValue ] -> [ position := aStream nextString ].
				[ $p asciiValue ] -> [ internalPosition := aStream nextString ].
				[ $q asciiValue ] -> [ internalQuery := aStream nextString ].
				[ $W asciiValue ] -> [ where := aStream nextString ].
				[ $F asciiValue ] -> [ file := aStream nextString ].
				[ $R asciiValue ] -> [ routine := aStream nextString ] }
			otherwise: [ aStream nextString ] ] repeat
]

{ #category : #accessing }
PG3ExceptionResponse >> routine [
	^ routine
]

{ #category : #accessing }
PG3ExceptionResponse >> routine: anObject [
	^ routine := anObject
]

{ #category : #accessing }
PG3ExceptionResponse >> severity [
	^ severity
]

{ #category : #accessing }
PG3ExceptionResponse >> severity: anObject [
	^ severity := anObject
]

{ #category : #accessing }
PG3ExceptionResponse >> where [
	^ where
]

{ #category : #accessing }
PG3ExceptionResponse >> where: anObject [
	^ where := anObject
]
