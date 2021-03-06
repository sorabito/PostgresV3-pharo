"
Part to flow for extended queries:
http://www.postgresql.org/docs/9.4/static/protocol-message-formats.html
Parse -> Bind -> Execute

Parse (F)

    Byte1('P')

        Identifies the message as a Parse command.
    Int32

        Length of message contents in bytes, including self.
    String

        The name of the destination prepared statement (an empty string selects the unnamed prepared statement).
    String

        The query string to be parsed.
    Int16

        The number of parameter data types specified (can be zero). Note that this is not an indication of the number of parameters that might appear in the query string, only the number that the frontend wants to prespecify types for.

    Then, for each parameter, there is the following:

    Int32

        Specifies the object ID of the parameter data type. Placing a zero here is equivalent to leaving the type unspecified.
"
Class {
	#name : #PG3Parse,
	#superclass : #PG3TypedMessage,
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #testing }
PG3Parse >> isRequest [

	^true
]

{ #category : #accessing }
PG3Parse >> typeByte [

	^80 "$P asciiValue"
]

{ #category : #'as yet unclassified' }
PG3Parse >> writeDataOn: aStream [
	self writeString: '' on: aStream
]
