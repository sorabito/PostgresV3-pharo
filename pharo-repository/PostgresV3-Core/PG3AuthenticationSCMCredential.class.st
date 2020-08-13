"
This response is only possible for local Unix-domain connections on platforms that support SCM credential messages. The frontend must issue an SCM credential message and then send a single data byte. (The contents of the data byte are uninteresting; it's only used to ensure that the server waits long enough to receive the credential message.) If the credential is acceptable, the server responds with an AuthenticationOk, otherwise it responds with an ErrorResponse. (This message type is only issued by pre-9.1 servers. It may eventually be removed from the protocol specification.)

"
Class {
	#name : #PG3AuthenticationSCMCredential,
	#superclass : #PG3AuthenticationMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #accessing }
PG3AuthenticationSCMCredential class >> subType [

	^6
]
