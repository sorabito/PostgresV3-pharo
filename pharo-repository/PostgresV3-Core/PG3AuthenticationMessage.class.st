"
Subclasses of this class represents the different authentication schemes supported by PG. The authentication type will be sent by the server. The client then should act accordingly.

If the authentication is successful, the server will send a PG3AuthenticationOkMessage. 
If it is not, PG3ErrorResponse will be sent and the connection will be closed.

Each subclass class comment contains the official PG documentation description.

See http://www.postgresql.org/docs/9.4/static/protocol-flow.html#AEN102761 
"
Class {
	#name : #PG3AuthenticationMessage,
	#superclass : #PG3TypedMessage,
	#classVars : [
		'AuthenticationDispatcher'
	],
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #initialization }
PG3AuthenticationMessage class >> initialize [

	super initialize.
	self initializeAuthenticationDispatcher
]

{ #category : #initialization }
PG3AuthenticationMessage class >> initializeAuthenticationDispatcher [
	" self initializeAuthenticationDispatcher "

	AuthenticationDispatcher := Array new: 10.
	self allSubclassesDo: [ :subclass |
		AuthenticationDispatcher at: subclass subType + 1 put: subclass ]
]

{ #category : #'instance creation' }
PG3AuthenticationMessage class >> readFrom: stream [

	| length |
	length := stream nextInt32 - 4.
	^(AuthenticationDispatcher at: stream nextInt32 + 1) new
		length: length;
		readFrom: stream;
		yourself
]

{ #category : #'instance creation' }
PG3AuthenticationMessage class >> readFrom: stream connection: connection [

	| length |
	length := stream nextInt32 - 4.
	^(AuthenticationDispatcher at: stream nextInt32 + 1) new
		connection: connection;
		length: length;
		readFrom: stream;
		yourself
]

{ #category : #accessing }
PG3AuthenticationMessage class >> subType [

	self subclassResponsibility
]

{ #category : #testing }
PG3AuthenticationMessage >> isResponse [

	^true
]

{ #category : #accessing }
PG3AuthenticationMessage >> typeByte [

	^82 "$R asciiValue"
]
