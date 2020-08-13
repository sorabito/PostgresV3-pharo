Class {
	#name : #PG3ServerState,
	#superclass : #Object,
	#instVars : [
		'transitions',
		'name',
		'stopState'
	],
	#category : #'PostgresV3-Core'
}

{ #category : #'protocols-startup' }
PG3ServerState class >> authenticatingStateDescription [

	(self state: #Authenticating)
		on: PG3AuthenticationOkMessage goto: #InitializingBackend; 
		
		on: PG3AuthenticationCleartextPassword 
		connectionDo: #respondToAuthenticationCleartextPasswordRequest:
		goto: #AuthenticatingWithCleartext;
		
		on: PG3AuthenticationMD5Password 
		connectionDo: #respondToAuthenticationMD5PasswordRequest:
		goto: #AuthenticatingWithMD5
]

{ #category : #'protocols-startup' }
PG3ServerState class >> authenticatingWithCleartextStateDescription [

	(self state: #AuthenticatingWithCleartext)
		on: PG3AuthenticationOkMessage goto: #InitializingBackend
]

{ #category : #'protocols-startup' }
PG3ServerState class >> authenticatingWithMD5StateDescription [

	(self state: #AuthenticatingWithMD5)
		on: PG3AuthenticationOkMessage goto: #InitializingBackend
]

{ #category : #actions }
PG3ServerState class >> createStateGraph [

	| states |
	states := IdentityDictionary new.
	[ self stateGraphDescription ]
		on: Notification
		do: [ :notification | notification resume: states ].
	^states
]

{ #category : #'protocols-simple query' }
PG3ServerState class >> gotCommandComplete [

	(self state: #GotCommandComplete)
		on: PG3CommandComplete
		connectionDo: #commandComplete:
		goto: #GotCommandComplete;
		on: PG3ReadyForQuery
		connectionDo: #readyForQuery:
		goto: #WaitingForQuery;
		on: PG3RowDescription
		connectionDo: #rowDescription:
		goto: #GotRowDescription;
		on: PG3ErrorResponse 
		connectionDo: #handleError:
		goto: #GotErrorResponseDuringSimpleQuery
]

{ #category : #'protocols-simple query' }
PG3ServerState class >> gotDataRow [

	(self state: #GotDataRow)
		on: PG3DataRow
		connectionDo: #dataRow:
		goto: #GotDataRow;
		on: PG3CommandComplete
		connectionDo: #commandComplete:
		goto: #GotCommandComplete;
		on: PG3ErrorResponse 
		connectionDo: #handleError:
		goto: #GotErrorResponseDuringSimpleQuery
]

{ #category : #'protocols-simple query' }
PG3ServerState class >> gotEmptyQueryResponse [

	(self state: #GotEmptyQueryResponse)
		on: PG3ReadyForQuery
		connectionDo: #readyForQuery:
		goto: #WaitingForQuery;
		on: PG3ErrorResponse 
		connectionDo: #handleError:
		goto: #GotErrorResponseDuringSimpleQuery
]

{ #category : #'protocols-simple query' }
PG3ServerState class >> gotErrorResponseDuringSimpleQuery [

	(self state: #GotErrorResponseDuringSimpleQuery)
		on: PG3ReadyForQuery
		connectionDo: #readyForQuery:
		goto: #WaitingForQuery
]

{ #category : #'protocols-simple query' }
PG3ServerState class >> gotRowDescription [

	(self state: #GotRowDescription)
		on: PG3DataRow
		connectionDo: #dataRow:
		goto: #GotDataRow;
		on: PG3CommandComplete
		connectionDo: #commandComplete:
		goto: #GotCommandComplete;
		on: PG3ErrorResponse 
		connectionDo: #handleError:
		goto: #GotErrorResponseDuringSimpleQuery
]

{ #category : #'protocols-startup' }
PG3ServerState class >> initializingBackendStateDescription [

	(self state: #InitializingBackend)
		on: PG3BackendKeyData
		connectionDo: #registerBackendKeyData:
		goto: #InitializingBackend;
		on: PG3ReadyForQuery
		connectionDo: #readyForQuery:
		goto: #WaitingForQuery
]

{ #category : #'protocols-simple query' }
PG3ServerState class >> querying [

	(self state: #Querying)
		on: PG3CommandComplete
		connectionDo: #commandComplete:
		goto: #GotCommandComplete;
		on: PG3RowDescription
		connectionDo: #rowDescription:
		goto: #GotRowDescription;
		on: PG3EmptyQueryResponse
		goto: #GotEmptyQueryResponse;
		on: PG3ErrorResponse 
		connectionDo: #handleError:
		goto: #GotErrorResponseDuringSimpleQuery
]

{ #category : #accessing }
PG3ServerState class >> state: aSymbol [

	^self states at: aSymbol ifAbsent: [
		| newState |
		newState := self states at: aSymbol put: (
			self new
				name: aSymbol;
				yourself).
		newState
			on: PG3NoticeResponse
			connectionDo: #receiveNotice:
			goto: aSymbol;
			on: PG3ParameterStatus 
			connectionDo: #addParameterStatus:
			goto: aSymbol;
			on: PG3NotificationResponse  
			connectionDo:  #receiveNotification:
			goto: aSymbol;
			yourself ].
]

{ #category : #accessing }
PG3ServerState class >> stateGraphDescription [

	self 
		authenticatingStateDescription;
		authenticatingWithMD5StateDescription;
		authenticatingWithCleartextStateDescription;
		initializingBackendStateDescription;
		waitingForQuery;
		querying;
		gotCommandComplete;
		gotRowDescription;
		gotDataRow;
		gotEmptyQueryResponse;
		gotErrorResponseDuringSimpleQuery
	
]

{ #category : #accessing }
PG3ServerState class >> states [

	^Notification signal
]

{ #category : #'protocols-startup' }
PG3ServerState class >> waitingForQuery [

	(self state: #WaitingForQuery)
		stopState
]

{ #category : #initialization }
PG3ServerState >> initialize [

	transitions := IdentityDictionary new.
	stopState := false
]

{ #category : #accessing }
PG3ServerState >> isStopState [

	^stopState
]

{ #category : #accessing }
PG3ServerState >> name [

	^name
]

{ #category : #accessing }
PG3ServerState >> name: aSymbol [

	name := aSymbol
]

{ #category : #actions }
PG3ServerState >> on: aPG3MessageClass connectionDo: selector goto: aSymbol [

	transitions at: aPG3MessageClass put: { (self state: aSymbol). selector }
]

{ #category : #actions }
PG3ServerState >> on: aPG3MessageClass do: aBlock goto: aSymbol [

	transitions at: aPG3MessageClass put: { (self state: aSymbol). aBlock }
]

{ #category : #actions }
PG3ServerState >> on: aPG3MessageClass goto: aSymbol [

	transitions at: aPG3MessageClass put: { (self state: aSymbol). nil }
]

{ #category : #printing }
PG3ServerState >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: name;
		nextPut: $)
]

{ #category : #actions }
PG3ServerState >> receive: aPG3TypedMessage from: connection [

	| action |
	action := transitions at: aPG3TypedMessage class ifAbsent: [ self error ].
	(action at: 2) ifNotNil: [
		connection 
			perform: (action at: 2) 
			with: aPG3TypedMessage ].
	^action at: 1
]

{ #category : #accessing }
PG3ServerState >> state: aSymbol [

	^self class state: aSymbol
]

{ #category : #actions }
PG3ServerState >> stopState [

	stopState := true
]
