"
I do the ""string conversion"" when the automaticStringConversion argument of a connection is false. I don't do anything just return the strings as they are.
"
Class {
	#name : #PG3NullTextConverter,
	#superclass : #PG3TextConverter,
	#category : #'PostgresV3-Core'
}

{ #category : #conversion }
PG3NullTextConverter >> convertFromSystemString: aString [

	^aString
]

{ #category : #conversion }
PG3NullTextConverter >> convertToSystemString: aString [
	"Do nothing."

	^aString
]
