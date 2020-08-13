"
I use Squeak's TextConverters to convert the strings between the Postgres server and Squeak.

Instance Variables
	textConverter:		<TextConverter>

textConverter
	- the text converter of Squeak I use for the conversion
"
Class {
	#name : #PG3DelegatingTextConverter,
	#superclass : #PG3TextConverter,
	#instVars : [
		'textConverter'
	],
	#category : #'PostgresV3-Core'
}

{ #category : #'as yet unclassified' }
PG3DelegatingTextConverter class >> for: encodingName [

	^self new
		textConverter: (TextConverter newForEncoding: encodingName);
		yourself
]

{ #category : #conversion }
PG3DelegatingTextConverter >> convertFromSystemString: aString [

	^aString convertToWithConverter: textConverter
]

{ #category : #conversion }
PG3DelegatingTextConverter >> convertToSystemString: aString [

	^aString convertFromWithConverter: textConverter
]

{ #category : #accessing }
PG3DelegatingTextConverter >> textConverter [
	^ textConverter
]

{ #category : #accessing }
PG3DelegatingTextConverter >> textConverter: aTextConverter [

	textConverter := aTextConverter
]
