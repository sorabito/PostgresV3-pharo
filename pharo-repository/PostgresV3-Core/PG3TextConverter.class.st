"
I convert the strings between the Postgres server and Squeak. I'm abstract, see my subclasses for details.
"
Class {
	#name : #PG3TextConverter,
	#superclass : #Object,
	#category : #'PostgresV3-Core'
}

{ #category : #conversion }
PG3TextConverter >> convertFromSqueak: aString [

	^self convertFromSystemString: aString
]

{ #category : #conversion }
PG3TextConverter >> convertFromSystemString: aString [

	self subclassResponsibility 
]

{ #category : #conversion }
PG3TextConverter >> convertToSqueak: aString [

	^self convertToSystemString: aString.
]

{ #category : #conversion }
PG3TextConverter >> convertToSystemString: aString [

	self subclassResponsibility 
]
