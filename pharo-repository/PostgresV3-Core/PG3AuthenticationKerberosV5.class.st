"
When receiving this message, the frontend must now take part in a Kerberos V5 authentication dialog (not described here, part of the Kerberos specification) with the server. If this is successful, the server responds with an AuthenticationOk, otherwise it responds with an ErrorResponse. This is no longer supported.


"
Class {
	#name : #PG3AuthenticationKerberosV5,
	#superclass : #PG3AuthenticationMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #accessing }
PG3AuthenticationKerberosV5 class >> subType [

	^2
]
