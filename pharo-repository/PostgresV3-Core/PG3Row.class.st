"
A PG3Row is an Array-like object which represents a row returned by a query. It can be accessed by index (via #at: and #at:put:) or by the name of the column sent to it as a unary message, if columnNameDictionary is not nil, the name of the column is a valid unary selector and the selector is not defined by Object or ProtoObject (the only exception is #name, which can be used as a column name). If the column name is not a valid unary selector or the selector is implemented by a superclass (Object or ProtoObject), then #atName: #atName:ifAbsent: and #atName:put: can be used to access the slots by name.

Instance Variables
	columnNameDictionary:		<IdentityDictionary>

columnNameDictionary
	- the IdentityDictionary which maps column names to indices, it's size should be the same as the PG3Row's size, it's keys should be symbols representing the column names and it's values should be integers between 1 the size of the row. All integers between 1 and row size should be present as a value.
"
Class {
	#name : #PG3Row,
	#superclass : #Object,
	#type : #variable,
	#instVars : [
		'columnNameDictionary'
	],
	#category : #'PostgresV3-Core'
}

{ #category : #'instance creation' }
PG3Row class >> for: anIdentityDictionary [

	^(self new: anIdentityDictionary size)
		columnNameDictionary: anIdentityDictionary;
		yourself
]

{ #category : #accessing }
PG3Row >> atName: aSymbol [

	^self at: (columnNameDictionary at: aSymbol)
]

{ #category : #accessing }
PG3Row >> atName: aSymbol ifAbsent: aBlock [

	^self at: (columnNameDictionary 
		at: aSymbol
		ifAbsent: [ ^aBlock value ])
]

{ #category : #accessing }
PG3Row >> atName: aSymbol put: anObject [

	^self at: (columnNameDictionary at: aSymbol) put: anObject
]

{ #category : #accessing }
PG3Row >> columnNameDictionary [

	^columnNameDictionary
]

{ #category : #accessing }
PG3Row >> columnNameDictionary: anIdentityDictionary [

	columnNameDictionary := anIdentityDictionary
]

{ #category : #accessing }
PG3Row >> doesNotUnderstand: aMessage [

	^(columnNameDictionary 
		at: aMessage selector
		ifAbsent: nil)
			ifNil: [ super doesNotUnderstand: aMessage ]
			ifNotNil: [ :index | self at: index ]
]

{ #category : #explorer }
PG3Row >> explorerContents [

	^Smalltalk at: #ObjectExplorerWrapper ifPresent: [ :objectExplorerWrapper |
		| instVarNames |
		instVarNames := self class allInstVarNames.
		Array new: self size + instVarNames size streamContents: [ :stream |
			instVarNames withIndexDo: [ :name :index | 
				| value |
				value := self instVarAt: index.
				stream nextPut: (
					objectExplorerWrapper
						with: value
						name: name
						model: value) ].
			columnNameDictionary 
				ifNil: [
					1 to: self size do: [ :index |
						stream nextPut: (objectExplorerWrapper
							with: (self at: index)
							name: index printString
							model: self) ] ]
				ifNotNil: [
					stream nextPutAll: (
						(columnNameDictionary associations
							sort: [ :a :b | a value < b value ])
							replace: [ :assoc |
								objectExplorerWrapper
									with: (self at: assoc value)
									name: assoc key, (' (', assoc value asString, ')')
									model: self ]) ] ] ]
]

{ #category : #accessing }
PG3Row >> indexOf: aSymbol [

	^columnNameDictionary at: aSymbol ifAbsent: 0
]

{ #category : #enumerating }
PG3Row >> keysAndValuesDo: aBlock [

	columnNameDictionary keysAndValuesDo: [ :key :value |
		aBlock value: key value: (self at: value) ]
]

{ #category : #accessing }
PG3Row >> name [

	^self atName: #name ifAbsent: [ super name ]
]

{ #category : #printing }
PG3Row >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	columnNameDictionary 
		ifNil: [
			1 to: self size do: [ :index |
				index = 1 ifFalse: [ aStream nextPutAll: ', ' ].
				aStream print: (self at: index) ] ]
		ifNotNil: [
			(columnNameDictionary associations
				sort: [ :a :b | a value < b value ])
				do: [ :assoc |
					aStream 
						nextPutAll: assoc key;
						nextPutAll: ': ';
						print: (self at: assoc value) ]
				separatedBy: [ aStream nextPut: $,; cr ] ].
	aStream nextPut: $)
]
