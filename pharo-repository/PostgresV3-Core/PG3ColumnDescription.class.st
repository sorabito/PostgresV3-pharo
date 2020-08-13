Class {
	#name : #PG3ColumnDescription,
	#superclass : #Object,
	#instVars : [
		'name',
		'tableId',
		'columnId',
		'typeId',
		'typeSize',
		'typeModifier',
		'formatCode'
	],
	#classInstVars : [
		'converterArray'
	],
	#category : #'PostgresV3-Core'
}

{ #category : #accessing }
PG3ColumnDescription class >> converterArray [

	^converterArray
]

{ #category : #initialization }
PG3ColumnDescription class >> initialize [

	super initialize.
	self initializeConverterArray


	 

]

{ #category : #initialization }
PG3ColumnDescription class >> initializeConverterArray [

	| textConverterSelectors |
	textConverterSelectors := self textConverterSelectors.
	converterArray := Array 
		new: (textConverterSelectors detectMax: [ :each | each first ]) first + 1 " make sure that the last element is the default element (#next:), because we will access the elements with #atOrLast:"
		withAll: #next:.
	textConverterSelectors do: [ :each |
		converterArray at: each first put: each second ]
	 

]

{ #category : #accessing }
PG3ColumnDescription class >> textConverterSelectors [

	^#(
			(16 #parseBooleanLength:) "bool"
			(17 #parseByteArrayLength:) "bytea"
			(18 #parseCharacterLength:) "char"
			(19 #parseStringLength:) "name"
			(20 #parseIntegerLength:) "int8"
			(21 #parseIntegerLength:) "int2"
			(22 #parseIntegerVectorLength:) "int2vector"
			(23 #parseIntegerLength:) "int4"	
			(24 #parseStringLength:) "regproc"
			(25 #parseStringLength:) "text"
			(26 #parseIntegerLength:) "oid"
			(114 #parseJsonLength:) "json"
			(142 #parseXmlLength:) "xml"
			(143 #parseXmlArrayLength:) "xml[]"
			(199 #parseJsonArrayLength:) "json[]"
			(1043 #parseStringLength:) "character varying"		
			(1042 #parseStringLength:) "char"		
			
			(1082 #parseDateLength:) "date"		
		
			(1114 #parseTimestampLength:) "timestamp"		
			(1184 #parseTimestampLength:) "timestamptz"

			(1700 #parseScaledDecimalLength:) "numeric"
		
			(700 #parseFloatLength:) "float4"
			(701 #parseFloatLength:) "float8"
				
			(705 #parseStringLength:) "unknown"
		
			(1000 #parseBooleanArrayLength:) "bool[]"
			(1003 #parseStringArrayLength:) "name[]"
			(1005 #parseIntegerArrayLength:) "int2[]"
			(1009 #parseStringArrayLength:) "text[]"
			(1007 #parseIntegerArrayLength:) "int4[]"
			(1014 #parseStringArrayLength:) "character[]"
			(1015 #parseStringArrayLength:) "character varying[]"
			(1016 #parseIntegerArrayLength:) "int2[]"
			(1021 #parseFloatArrayLength:) "float4[]"
			(1022 #parseFloatArrayLength:) "float8[]"			
			(1231 #parseScaledDecimalArrayLength:) "numeric[]"
		
			(1790 #parseStringLength:) "refcursor[]"
		)
]

{ #category : #accessing }
PG3ColumnDescription >> columnId [
	^ columnId
]

{ #category : #accessing }
PG3ColumnDescription >> columnId: anObject [
	columnId := anObject
]

{ #category : #accessing }
PG3ColumnDescription >> converterSelector [

	formatCode = 0 ifFalse: [ 
		" not text format "
		^#next: ].
	^self class converterArray atOrLast: typeId
]

{ #category : #accessing }
PG3ColumnDescription >> formatCode [
	^ formatCode
]

{ #category : #accessing }
PG3ColumnDescription >> formatCode: anObject [
	formatCode := anObject
]

{ #category : #accessing }
PG3ColumnDescription >> name [
	^ name
]

{ #category : #accessing }
PG3ColumnDescription >> name: anObject [
	name := anObject
]

{ #category : #accessing }
PG3ColumnDescription >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: name;
		nextPutAll: ', ';
		print: typeId;
		nextPut: $)
]

{ #category : #accessing }
PG3ColumnDescription >> tableId [
	^ tableId
]

{ #category : #accessing }
PG3ColumnDescription >> tableId: anObject [
	tableId := anObject
]

{ #category : #accessing }
PG3ColumnDescription >> typeId [
	^ typeId
]

{ #category : #accessing }
PG3ColumnDescription >> typeId: anObject [
	typeId := anObject
]

{ #category : #accessing }
PG3ColumnDescription >> typeModifier [
	^ typeModifier
]

{ #category : #accessing }
PG3ColumnDescription >> typeModifier: anObject [
	typeModifier := anObject
]

{ #category : #accessing }
PG3ColumnDescription >> typeSize [
	^ typeSize
]

{ #category : #accessing }
PG3ColumnDescription >> typeSize: anObject [
	typeSize := anObject
]
