"
When receiving this message, the frontend must now send a PasswordMessage containing the password (with username) encrypted via MD5, then encrypted again using the 4-byte random salt specified in the AuthenticationMD5Password message. If this is the correct password, the server responds with an AuthenticationOk, otherwise it responds with an ErrorResponse. The actual PasswordMessage can be computed in SQL as concat('md5', md5(concat(md5(concat(password, username)), random-salt))). (Keep in mind the md5() function returns its result as a hex string.)

"
Class {
	#name : #PG3AuthenticationMD5Password,
	#superclass : #PG3AuthenticationMessage,
	#instVars : [
		'salt'
	],
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #accessing }
PG3AuthenticationMD5Password class >> subType [

	^5
]

{ #category : #'initialize-release' }
PG3AuthenticationMD5Password >> readFrom: stream [

	salt := stream next: 4
]

{ #category : #accessing }
PG3AuthenticationMD5Password >> salt [

	^salt
]
