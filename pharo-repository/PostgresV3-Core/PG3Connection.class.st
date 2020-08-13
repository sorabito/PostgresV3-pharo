"
Example usage:

args := PG3ConnectionArguments new
  hostname: '127.0.0.1';
  port: 5432;
  username: 'fstephany';
  password: '';
  databaseName: 'creative-mons'
  yourself.
 
connection := args newConnection.
connection startup.

rs := connection execute: 'SELECT * FROM entries;'.
"
Class {
	#name : #PG3Connection,
	#superclass : #Object,
	#instVars : [
		'socket',
		'arguments',
		'socketReadStream',
		'state',
		'processId',
		'secretKey',
		'parameters',
		'states',
		'resultSets',
		'transactionState',
		'currentConverterSelectors',
		'textConverter',
		'noticeHandler',
		'commandCompleteHandler',
		'currentRowClass'
	],
	#category : #'PostgresV3-Core'
}

{ #category : #'startup-protocol' }
PG3Connection >> addParameterStatus: aPG3ParameterStatus [ 
	
	parameters at: aPG3ParameterStatus name put: aPG3ParameterStatus value
]

{ #category : #accessing }
PG3Connection >> arguments [

	^arguments
]

{ #category : #accessing }
PG3Connection >> arguments: aPG3ConnectionArguments [

	arguments := aPG3ConnectionArguments
]

{ #category : #actions }
PG3Connection >> cancelRequest [

	| message |
	message := PG3CancelRequest for: self.
	PG3Connection new
		arguments: arguments;
		ensureConnection;
		sendMessage: message
]

{ #category : #'simple-query-protocol' }
PG3Connection >> commandComplete: aPG3CommandCompleteMessage [

	commandCompleteHandler ifNotNil: [
		commandCompleteHandler value: aPG3CommandCompleteMessage ]
]

{ #category : #accessing }
PG3Connection >> commandCompleteHandler: aBlockOrNil [

	commandCompleteHandler := aBlockOrNil
]

{ #category : #accessing }
PG3Connection >> currentConverterSelectors [

	^currentConverterSelectors
]

{ #category : #accessing }
PG3Connection >> currentRowClass [

	^currentRowClass ifNil: [ PG3Row ]
]

{ #category : #'simple-query-protocol' }
PG3Connection >> dataRow: aPG3DataRow [

	resultSets last rows add: aPG3DataRow values
]

{ #category : #'transaction helpers' }
PG3Connection >> deferAllConstraints [

	self execute: 'set constraints all deferred'
]

{ #category : #private }
PG3Connection >> ensureConnection [

	self initializeSocket.
	socket 
		connectTo: (NetNameResolver
			addressForName: arguments hostname
			timeout: 20)
		port: arguments port
		waitForConnectionFor: arguments connectTimeout
]

{ #category : #'simple-query-protocol' }
PG3Connection >> execute: aString [
	"Execute the query given in aString with the simple query protocol"

	^self execute: aString rowClass: nil
]

{ #category : #'simple-query-protocol' }
PG3Connection >> execute: aString rowClass: aClass [
	"Execute the query given in aString with the simple query protocol"

	| returnedResultSets |
	socketReadStream resetOffset.
	currentRowClass := aClass.
	self sendMessage: (PG3Query new
		queryString: (textConverter convertFromSystemString: aString);
		yourself).
	resultSets := OrderedCollection new: 3.
	state := states at: #Querying.
	self processStates.
	returnedResultSets := resultSets.
	resultSets := nil. "We no longer need them here, and we don't want to hold a reference to them."
	currentRowClass := nil.
	^returnedResultSets
]

{ #category : #'extended-query-protocol' }
PG3Connection >> execute: queryString withArguments: argumentsCollection [
	" 1. Send PARSE
	  2. BIND the parameters
	  3. Execute.
	  4. Profit
	"
	

]

{ #category : #actions }
PG3Connection >> handleError: aPG3ErrorResponse [

	resultSets add: aPG3ErrorResponse
]

{ #category : #initialization }
PG3Connection >> initializeSocket [

	socket ifNotNil: [ socket destroy ].
	socket := Socket tcpCreateIfFail: [ self error: 'Could not create socket!' ].
	socketReadStream := PG3SocketReadStream on: socket
]

{ #category : #testing }
PG3Connection >> isConnected [

	^socket isConnected
]

{ #category : #testing }
PG3Connection >> isIdle [

	^transactionState = 73 "$I asciiValue"
]

{ #category : #testing }
PG3Connection >> isInFailedTransaction [

	^transactionState = 69 "$E asciiValue"
]

{ #category : #testing }
PG3Connection >> isInTransaction [

	^transactionState = 84 "$T asciiValue"
]

{ #category : #testing }
PG3Connection >> isQuerying [

	^state
		ifNil: [ false ]
		ifNotNil: [
			state name = #Querying ]
		
]

{ #category : #testing }
PG3Connection >> isReadyForQuery [

	^state
		ifNil: [ false ]
		ifNotNil: [
			state name = #WaitingForQuery ]
		
]

{ #category : #'startup-protocol' }
PG3Connection >> md5HashMessage: aString [

	^Smalltalk globals
		at: #MD5
		ifPresent: [ :md5 | (md5 hashMessage: aString) hex asLowercase ]
		ifAbsent: [ WebUtils md5Digest: aString ]
]

{ #category : #accessing }
PG3Connection >> noticeHandler: aBlockOrNil [

	noticeHandler := aBlockOrNil
]

{ #category : #accessing }
PG3Connection >> processId [

	^processId
]

{ #category : #actions }
PG3Connection >> processStates [
	
	[ state isStopState ] whileFalse: [
		| message |
		message := self receiveMessage.
		state := state receive: message from: self ]
]

{ #category : #'simple-query-protocol' }
PG3Connection >> readyForQuery: aPG3ReadyForQuery [

	transactionState := aPG3ReadyForQuery transactionState

	
]

{ #category : #actions }
PG3Connection >> receiveMessage [

	^PG3TypedMessage dispatchFrom: socketReadStream connection: self
]

{ #category : #'simple-query-protocol' }
PG3Connection >> receiveNotice: aPG3NoticeResponse [

	noticeHandler ifNotNil: [ noticeHandler value: aPG3NoticeResponse ]
]

{ #category : #'simple-query-protocol' }
PG3Connection >> receiveNotification: aPG3NotificationResponse [

	"do nothing"
]

{ #category : #'startup-protocol' }
PG3Connection >> registerBackendKeyData: aPG3BackendKeyData [

	processId := aPG3BackendKeyData processId.
	secretKey := aPG3BackendKeyData secretKey
]

{ #category : #'transaction helpers' }
PG3Connection >> releaseSavepoint: aString [

	self execute: 'release ', aString asPG3SqlIdentifier
]

{ #category : #'startup-protocol' }
PG3Connection >> respondToAuthenticationCleartextPasswordRequest: message [
	self sendMessage: (
		PG3PasswordMessage new
			password: arguments password ;
			yourself) 
]

{ #category : #'startup-protocol' }
PG3Connection >> respondToAuthenticationMD5PasswordRequest: message [

	self sendMessage: (
		PG3PasswordMessage new
			password: 'md5', (
				self md5HashMessage: (
					(self md5HashMessage: (
						arguments password, arguments username)), 
					message salt asString));
			yourself)
]

{ #category : #'transaction helpers' }
PG3Connection >> rollback [

	self execute: 'rollback'
]

{ #category : #'transaction helpers' }
PG3Connection >> rollbackTo: aString [

	self execute: 'rollback to ', aString asPG3SqlIdentifier
]

{ #category : #'simple-query-protocol' }
PG3Connection >> rowDescription: aPG3RowDescription [ 

	resultSets add: (PG3ResultSet new
		rowDescription: aPG3RowDescription;
		rows: OrderedCollection new;
		yourself).
	currentConverterSelectors := aPG3RowDescription converterSelectors
]

{ #category : #'transaction helpers' }
PG3Connection >> savepoint: aString [

	self execute: 'savepoint ', aString asPG3SqlIdentifier
]

{ #category : #accessing }
PG3Connection >> secretKey [

	^secretKey
]

{ #category : #actions }
PG3Connection >> sendMessage: aPG3Message [

	| stream bytes |
	bytes := ByteArray new: 8192.
	stream := WriteStream on: bytes from: 1 to: bytes size.
	aPG3Message writeOn: stream.
	socket sendData: stream originalContents count: stream position
]

{ #category : #'transaction helpers' }
PG3Connection >> show: aString [

	^self execute: 'show ', aString asPG3SqlIdentifier
]

{ #category : #accessing }
PG3Connection >> socket [

	^socket
]

{ #category : #accessing }
PG3Connection >> socketReadStream [

	^socketReadStream
]

{ #category : #'startup-protocol' }
PG3Connection >> startup [

	self ensureConnection.
	self sendMessage: (PG3StartupMessage for: self).
	states := PG3ServerState createStateGraph.
	state := states at: #Authenticating.
	parameters := Dictionary new.
	self processStates.
	arguments automaticStringConversion
		ifFalse: [ self textConverter: PG3NullTextConverter new ]
		ifTrue: [ 
			self textConverter:(PG3DelegatingTextConverter 
				for: (parameters 
					at: 'server_encoding'
					ifAbsent: [ 'UTF8' ])) ]
]

{ #category : #accessing }
PG3Connection >> state [

	^state
]

{ #category : #accessing }
PG3Connection >> state: aPG3ServerState [

	state := aPG3ServerState
]

{ #category : #actions }
PG3Connection >> terminate [

	socket ifNil: [ ^self ].
	socket isConnected ifTrue: [
		self sendMessage: PG3Terminate new.
		socket close ]
]

{ #category : #accessing }
PG3Connection >> textConverter: aPG3TextConverter [

	textConverter := aPG3TextConverter.
	socketReadStream textConverter: aPG3TextConverter.
]
