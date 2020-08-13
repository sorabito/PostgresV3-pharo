"
Indicates that rows are about to be returned in response to a SELECT, FETCH, etc query. The contents of this message describe the column layout of the rows. This will be followed by a DataRow message for each row being returned to the frontend.
"
Class {
	#name : #PG3RowDescription,
	#superclass : #PG3TypedMessage,
	#instVars : [
		'columnDescriptions'
	],
	#category : #'PostgresV3-Core-Messages'
}

{ #category : #accessing }
PG3RowDescription >> columnNameDictionary [

	| dictionary |
	dictionary := IdentityDictionary new: columnDescriptions size * 2.
	columnDescriptions doWithIndex: [ :columnDescription :index |
		dictionary at: columnDescription name asSymbol put: index ].
	^dictionary
]

{ #category : #accessing }
PG3RowDescription >> columnsDescriptions [

	^columnDescriptions
]

{ #category : #accessing }
PG3RowDescription >> converterSelectors [

	^columnDescriptions collect: [ :each | each converterSelector ]
]

{ #category : #testing }
PG3RowDescription >> isResponse [

	^true
]

{ #category : #'initialize-release' }
PG3RowDescription >> readFrom: stream [

	columnDescriptions := Array new: stream nextInt16.
	1 to: columnDescriptions size do: [ :index |
		columnDescriptions at: index put: (
			PG3ColumnDescription new
				name: stream nextString;
				tableId: stream nextInt32;
				columnId: stream nextInt16;
				typeId: stream nextInt32;
				typeSize: stream nextInt16;
				typeModifier: stream nextInt32;
				formatCode: stream nextInt16;
				yourself) ]
]

{ #category : #accessing }
PG3RowDescription >> typeByte [

	^84 "$T asciiValue"
]
