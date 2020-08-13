"
A PG3ResultSet represents the result of a single query. It contains the description of the rows and the rows themselves.

Instance Variables
	rowDescription:		<PG3RowDescription>
	rows:		<SequenceableCollection>

rowDescription
	- this object describes the structure of the rows.

rows
	- the rows returned by the query. It can be empty.

"
Class {
	#name : #PG3ResultSet,
	#superclass : #Object,
	#instVars : [
		'rowDescription',
		'rows'
	],
	#category : #'PostgresV3-Core'
}

{ #category : #accessing }
PG3ResultSet >> rowDescription [

	^rowDescription
]

{ #category : #accessing }
PG3ResultSet >> rowDescription: aPG3RowDescription [

	rowDescription := aPG3RowDescription
]

{ #category : #accessing }
PG3ResultSet >> rows [

	^rows
]

{ #category : #accessing }
PG3ResultSet >> rows: aSequenceableCollection [

	rows := aSequenceableCollection
]

{ #category : #accessing }
PG3ResultSet >> rowsWithColumnNameDictionary [
	"Pass the columnNameDictionary to all rows then return the rows."
	
	| columnNameDictionary |
	columnNameDictionary := rowDescription columnNameDictionary.
	rows do: [ :each | 
		each columnNameDictionary: columnNameDictionary ].
	^rows

]
