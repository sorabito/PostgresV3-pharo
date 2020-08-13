"
I hold the arguments of a connection which are used when the connection is being established.

Instance Variables
	automaticStringConversion:		<Boolean>
	connectTimeout:		<Integer>
	databaseName:		<String>
	hostname:		<String>
	password:		<String>
	port:		<Integer>
	username:		<String>

automaticStringConversion
	- if true, then automatically create and install a TextConverter object based on the 'server_encoding' parameter sent by the server, otherwise don't perform character encoding/decoding. Default is true.

connectTimeout
	- the number of milliseconds to wait for a connection to be created. Default 5000 (5 seconds).

databaseName
	- the name of the database to connect to

hostname
	- the name of the host to connect to

password
	- the password of the account to be used

port
	- the port of the server to connect to. Default 5432.

username
	- the username of the account to be used
	
	
Usage examples:
===========

Setting all arguments:
arguments := PG3ConnectionArguments new
	hostname: 'localhost';
	databaseName: 'db2;
	username: 'user';
	password: 'secret';
	automaticStringConversion: false;
	connectTimeout: 1000;
	yourself
	
The easiest way to create a connection setting only the necessary arguments:
connection := PG3ConnectionArguments new
	hostname: 'localhost';
	databaseName: 'db2;
	username: 'squeaker';
	password: 'secret';
	newConnection.
	
"
Class {
	#name : #PG3ConnectionArguments,
	#superclass : #Object,
	#instVars : [
		'username',
		'password',
		'databaseName',
		'hostname',
		'port',
		'connectTimeout',
		'automaticStringConversion'
	],
	#category : #'PostgresV3-Core'
}

{ #category : #accessing }
PG3ConnectionArguments >> automaticStringConversion [

	^automaticStringConversion ifNil: [ true ]
]

{ #category : #accessing }
PG3ConnectionArguments >> automaticStringConversion: aBoolean [

	automaticStringConversion := aBoolean
]

{ #category : #accessing }
PG3ConnectionArguments >> connectTimeout [
	
	^connectTimeout ifNil: [ 5000 ]
]

{ #category : #accessing }
PG3ConnectionArguments >> connectTimeout: milliseconds [ 
	
	connectTimeout := milliseconds
]

{ #category : #accessing }
PG3ConnectionArguments >> databaseName [

	^databaseName
]

{ #category : #accessing }
PG3ConnectionArguments >> databaseName: aString [

	databaseName := aString
]

{ #category : #accessing }
PG3ConnectionArguments >> hostname [

	^hostname
]

{ #category : #accessing }
PG3ConnectionArguments >> hostname: aString [

	hostname := aString
]

{ #category : #'connection creation' }
PG3ConnectionArguments >> newConnection [
	"Create and return a new connection with these arguments."

	^PG3Connection new
		arguments: self;
		yourself
]

{ #category : #accessing }
PG3ConnectionArguments >> password [

	^password
]

{ #category : #accessing }
PG3ConnectionArguments >> password: aString [

	password := aString
]

{ #category : #accessing }
PG3ConnectionArguments >> port [

	^port
]

{ #category : #accessing }
PG3ConnectionArguments >> port: anInteger [

	port := anInteger
]

{ #category : #accessing }
PG3ConnectionArguments >> username [

	^username
]

{ #category : #accessing }
PG3ConnectionArguments >> username: aString [

	username := aString
]
