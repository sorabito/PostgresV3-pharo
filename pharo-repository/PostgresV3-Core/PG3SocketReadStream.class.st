Class {
	#name : #PG3SocketReadStream,
	#superclass : #Object,
	#instVars : [
		'buffer',
		'position',
		'readLimit',
		'socket',
		'textConverter',
		'offset'
	],
	#category : #'PostgresV3-Core'
}

{ #category : #'instance creation' }
PG3SocketReadStream class >> on: socket [

	^self basicNew
		socket: socket;
		initialize;
		yourself
]

{ #category : #'accessing-tests' }
PG3SocketReadStream >> buffer [

	^buffer
]

{ #category : #'parsing-private' }
PG3SocketReadStream >> hasInfinityLength: anInteger [
	"possible values are '-infinity' and 'infinity' with lengths 8 and 9"
	^ anInteger
		between: 8
		and: 9
]

{ #category : #initialization }
PG3SocketReadStream >> initialize [

	buffer := ByteArray new: 8192.
	readLimit := 0.
	position := 0.
	offset := 0
]

{ #category : #'object creation' }
PG3SocketReadStream >> newDateAndTimeYear: year month: month day: day [

	^self
		newDateAndTimeYear: year
		month: month
		day: day
		seconds: 0
		nanoSeconds: 0
		offset: Duration zero
]

{ #category : #'object creation' }
PG3SocketReadStream >> newDateAndTimeYear: year month: month day: day seconds: seconds nanoSeconds: nanoSeconds offset: offset [

	| p q r s |
	p := month - 14 quo: 12.
	q := year + 4800 + p.
	r := month - 2 - (12 * p).
	s := (year + 4900 + p) quo: 100.
	^DateAndTime basicNew
		setJdn: (1461 * q quo: 4) + (367 * r quo: 12) - (3 * s quo: 4) + day - 32075
		seconds: seconds
		nano: nanoSeconds
		offset: offset;
		yourself
	
]

{ #category : #accessing }
PG3SocketReadStream >> next [

	<primitive: 65>
	[ position < readLimit ] whileFalse: [ self receiveData ].
	^buffer at: (position := position + 1)
]

{ #category : #accessing }
PG3SocketReadStream >> next: count [

	| byteArray bytesAvailable |
	byteArray := ByteArray basicNew: count.
	count < 14 ifTrue: [ 
		1 to: count do: [ :i |
			byteArray at: i put: self next ].
		^byteArray ].
	(bytesAvailable := readLimit - position) >= count ifTrue: [ 
		byteArray replaceFrom: 1 to: count with: buffer startingAt: position + 1.
		position := position + count.
		^byteArray ].
	byteArray replaceFrom: 1 to: bytesAvailable with: buffer startingAt: position + 1.
	readLimit := position.
	[ bytesAvailable < count ] whileTrue: [
		bytesAvailable := bytesAvailable + (
			socket 
				waitForData;
				receiveSomeDataInto: byteArray startingAt: bytesAvailable + 1) ].
	^byteArray
]

{ #category : #accessing }
PG3SocketReadStream >> nextInt16 [

	| n |
	(n := self next * 256 + self next) > 16r7FFF
		ifFalse: [ ^n ]
		ifTrue: [ ^n - 16r10000 ]
]

{ #category : #accessing }
PG3SocketReadStream >> nextInt32 [

	| byte result |
	(byte := self next) <= 16r7F "Is the result non-negative?"
		ifTrue: [
			byte <= 16r3F ifTrue: [ "Small"
				^byte * 256 + self next * 256 + self next * 256 + self next ].
			"Large"
			^(LargePositiveInteger basicNew: 4)
				digitAt: 1 put: byte;
				digitAt: 2 put: self next;
				digitAt: 3 put: self next;
				digitAt: 4 put: self next;
				yourself ].
	"Negative"
	byte >= 16rC0 ifTrue: [ "Small"
		^-1 - ((byte * 256 + self next * 256 + self next bitXor: 16rFFFFFF) * 256 + (self next bitXor: 255)) ].
	"Large"	
	result := LargeNegativeInteger basicNew: 4.
	result 
		digitAt: 4 put: (byte bitXor: 255);
		digitAt: 3 put: (self next bitXor: 255);
		digitAt: 2 put: (self next bitXor: 255).
	byte := self next bitXor: 255.
	byte > 0 ifTrue: [ "Save a LargeInteger creation and operation"
		result digitAt: 1 put: byte - 1.
		^result ].
	result digitAt: 1 put: byte.
	^result - 1
]

{ #category : #accessing }
PG3SocketReadStream >> nextInt8 [

	| n |
	(n := self next) > 16r7F
		ifFalse: [ ^n ]
		ifTrue: [ ^n - 16r100 ]
]

{ #category : #accessing }
PG3SocketReadStream >> nextString [

	^String streamContents: [ :stream |
		| next |
		[ (next := self next) ~= 0 ] whileTrue: [ 
			stream nextPut: (Character value: next) ] ]
]

{ #category : #parsing }
PG3SocketReadStream >> parseArrayWith: aBlock length: length [

	| endIndex |
	endIndex := offset + position + length - 1.
	^Array streamContents: [ :stream |
		self next. "skip ${"
		[ offset + position < endIndex ] whileTrue: [ 
			stream nextPut: aBlock value.
			self next. " skip $, and $} " ].
		offset + position = endIndex ifTrue: [ self next ] "skip optional $}" ]
]

{ #category : #parsing }
PG3SocketReadStream >> parseBoolean [

	^self next = 116 " $t asciiValue "
]

{ #category : #parsing }
PG3SocketReadStream >> parseBooleanArrayLength: length [

	^self parseArrayWith: [ self parseNullOr: [ self parseBoolean ] ] length: length
]

{ #category : #parsing }
PG3SocketReadStream >> parseBooleanLength: length [

	^self next = 116 "$t asciiValue"
	
		
]

{ #category : #parsing }
PG3SocketReadStream >> parseByteArrayLength: length [

	| writeStream i |
	writeStream := WriteStream on: (ByteArray new: length).
	i := 1.
	[ i <= length ] whileTrue: [
		| byte1 |
		(byte1 := self next) = 92 "$\ asciiValue " 
			ifTrue: [
				| byte2 |
				(byte2 := self next) = 92 "$\ asciiValue "
					ifTrue: [ 
						writeStream nextPut: 92.
						i := i + 2 ]
					ifFalse: [ 
						writeStream nextPut: (((byte2 - 48) * 8) + self next - 48) * 8 + self next - 48.
						i := i + 4 ] ]
			ifFalse: [
				writeStream nextPut: byte1.
				i := i + 1 ] ].
	writeStream position = length
		ifTrue: [ ^writeStream originalContents ]
		ifFalse: [ ^writeStream contents ]
]

{ #category : #parsing }
PG3SocketReadStream >> parseCharacterLength: length [

	^Character value: self next
]

{ #category : #parsing }
PG3SocketReadStream >> parseDateLength: length [

	| year month day |
	year := self parseIntegerUpTo: 45 "$- asciiValue".
	month := self parseIntegerLength: 2.
	self next.
	day := self parseIntegerLength: 2.
	year < 0 ifTrue: [ "parse ' BC'"
		self next: 3 ].
	^Date 
		starting: (self newDateAndTimeYear: year month: month day: day)	
		duration: (Duration seconds: 86400)
	
]

{ #category : #parsing }
PG3SocketReadStream >> parseEscapedStringInArray [

	^textConverter convertToSystemString: (String streamContents: [ :stream |
		| byte notEscaped |
		notEscaped := true.
		[ (byte := self next) = 34 and: [ notEscaped ] ] whileFalse: [
			notEscaped
				ifFalse: [
					stream nextPut: (Character value: byte).
					notEscaped := true ]
				ifTrue: [
					byte = 92 "$\ asciiValue"
						ifTrue: [ notEscaped := false ]
						ifFalse: [ 
							stream nextPut: (Character value: byte) ] ] ] ])
]

{ #category : #parsing }
PG3SocketReadStream >> parseFloatArrayLength: length [
	^ self
		parseArrayWith: [ self parseNullOr: [
			self parseNextArrayElementWithLength: [ :elementLength |
				self parseFloatLength: elementLength ] ] ]
		length: length
]

{ #category : #parsing }
PG3SocketReadStream >> parseFloatLength: length [
	
	| digit i negative exponent mantissa exponent2 |
	i := 1.
	(negative := (digit := self next - 48) = -3) "$-"
		ifTrue: [ 
			digit := self next - 48.
			i := 2 ].
	digit = 30 " $N asciiValue - 48 NaN " ifTrue: [ 
		self next: 2.
		^Float nan ].
	digit = 25 " $I asciiValue - 48 [-]Infinity " ifTrue: [
		self next: 7.
		negative
			ifTrue: [ ^Float infinity negated ]
			ifFalse: [ ^Float infinity ] ].
	mantissa := digit.
	[ i = length or: [ 
		digit = -2 " $. asciiValue - 48 " or: [ 
			digit =  53 " $e asciiValue - 48 " ] ] ] whileFalse: [
		mantissa := mantissa * 10 + (digit := self next - 48).
		i := i + 1 ].
	i = length ifTrue: [ 
		negative ifTrue: [ ^mantissa negated asFloat ].
		^mantissa asFloat ].
	mantissa := mantissa - digit // 10.
	exponent := 0.
	digit = -2 " $. asciiValue - 48 " ifTrue: [ 
		[ i = length or: [ 
			digit = 53 " $e asciiValue - 48 " ] ] whileFalse: [
			mantissa := mantissa * 10 + (digit := self next - 48).
			exponent := exponent - 1.
			i := i + 1 ].
		digit = 53 ifTrue: [ 
			mantissa := mantissa - 53 // 10.
			exponent := exponent + 1 ] ].
	negative ifTrue: [ mantissa := mantissa negated ].
	mantissa := mantissa asFloat.
	i = length ifTrue: [
		^mantissa * #(0.1 0.01 0.001 0.0001 1.0e-5 1.0e-6 1.0e-7 1.0e-8 1.0e-9 1.0e-10 1.0e-11 1.0e-12 1.0e-13 1.0e-14 1.0e-15 1.0e-16 1.0e-17) at: exponent negated ].
	negative := 44 - self next. " $- asciiValue = 45 $+ asciiValue = 43 => negative = +-1 "
	i := i + 1.
	exponent2 := 0.
	[ i = length ] whileFalse: [
		exponent2 := exponent2 * 10 + (self next - 48).
		i := i + 1 ].
	exponent := exponent2 * negative + exponent.
	^mantissa * (10.0 raisedTo: exponent)
]

{ #category : #parsing }
PG3SocketReadStream >> parseInfinityLength: length onSuccessDo: aBlock [
	| currentPosition result |
	(self hasInfinityLength: length) ifFalse: [ ^ self ].

	currentPosition := self position.
	result := self parseStringLength: length.
	(result = 'infinity' or: [ result = '-infinity' ])
		ifFalse: [ self position: currentPosition ]
		ifTrue: [
			self position: currentPosition + length.
			aBlock value: (result = 'infinity'
				ifTrue: [ aBlock value: InfiniteFuture new ]
				ifFalse: [ InfinitePast new ]) ]
]

{ #category : #parsing }
PG3SocketReadStream >> parseInteger [

	| digit number negative |
	(negative := (number := self next - 48) = -3) "$-"
		ifTrue: [ number := 0 ].
	[ (digit := self next - 48) >= 0 and: [ digit <= 9 ] ] whileTrue: [
		number := number * 10 + digit ].
	position := position - 1. "Leave the separator on the stream."
	negative ifTrue: [ ^number negated ].
	^number
]

{ #category : #parsing }
PG3SocketReadStream >> parseIntegerArrayLength: length [

	^self parseArrayWith: [ self parseNullOr: [ self parseInteger ] ] length: length
]

{ #category : #parsing }
PG3SocketReadStream >> parseIntegerLength: length [

	| number negative |
	(negative := (number := self next - 48) = -3) "$-"
		ifTrue: [ number := 0 ].
	2 to: length do: [ :index |
		number := number * 10 + (self next - 48) ].
	negative ifTrue: [ ^number negated ].
	^number
]

{ #category : #parsing }
PG3SocketReadStream >> parseIntegerUpTo: separatorByte [

	| byte number negative |
	(negative := (number := self next - 48) = -3) "$-"
		ifTrue: [ number := 0 ].
	[ (byte := self next) = separatorByte ] whileFalse: [
		number := number * 10 + byte - 48 ].
	negative ifTrue: [ ^number negated ].
	^number
]

{ #category : #parsing }
PG3SocketReadStream >> parseIntegerVectorLength: length [

	| writeStream i |
	writeStream := WriteStream on: (Array new: length).
	i := 1.
	[ i <= length ] whileTrue: [
		| negative number byte |
		(negative := (number := self next - 48) = -3) "$-"
			ifTrue: [ number := 0 ].
		i := i + 1.
		[ i > length or: [ i := i + 1. (byte := self next) = 32 ] ] whileFalse: [
			number := number * 10 + byte - 48 ].
		writeStream nextPut: (negative 
			ifTrue: [ number negated ]
			ifFalse: [ number ]) ].
	^writeStream contents
]

{ #category : #parsing }
PG3SocketReadStream >> parseJsonArrayLength: length [

	| result |
	result  := self parseStringArrayLength: length.
	(Smalltalk classNamed: 'Json') ifNotNil: [ :json |
		result replace: [ :each | json readFrom: each readStream ] ].
	^result
]

{ #category : #parsing }
PG3SocketReadStream >> parseJsonLength: length [

	| result |
	result := self parseStringLength: length.
	(Smalltalk classNamed: 'Json') ifNotNil: [ :json |
		^json readFrom: result readStream ].
	^result
]

{ #category : #'parsing-private' }
PG3SocketReadStream >> parseNextArrayElementWithLength: aBlock [
	| nextBytes |
	nextBytes := self peekUpTo: 44. "$, asciiValue"
	nextBytes := nextBytes last = 125 "$} asciiValue"
		ifTrue: [ nextBytes allButLast ]
		ifFalse: [ nextBytes ].
	^ aBlock value: nextBytes size
]

{ #category : #parsing }
PG3SocketReadStream >> parseNullOr: aBlock [

	self next = 78 "$N asciiValue"
		ifTrue: [
			(self next = 85 and: [
				self next = 76 and: [
					self next = 76 ] ])
			ifTrue: [ ^nil ]
			ifFalse: [ self error: 'Couldn''t parse null!' ] ]
		ifFalse: [
			position := position - 1.
			^aBlock value ]
	
		
]

{ #category : #parsing }
PG3SocketReadStream >> parseScaledDecimalArrayLength: length [
	^ self
		parseArrayWith: [ self parseNullOr: [
			self parseNextArrayElementWithLength: [ :elementLength |
				self parseScaledDecimalLength: elementLength ] ] ]
		length: length
]

{ #category : #parsing }
PG3SocketReadStream >> parseScaledDecimalLength: length [

	| byte i numerator negative dotPosition |
	(negative := (numerator := self next - 48) = -3) "$-"
		ifTrue: [ numerator := 0 ].
	numerator = 30 " $N asciiValue - 48 NaN " ifTrue: [ 
		self next: 2.
		^Float nan ].
	i := 1.
	[ i = length ] whileFalse: [
		(byte := self next) = 46 " $. asciiValue " ifTrue: [	
			i := i + 1.
			dotPosition := i.
			byte := self next. ].
		numerator := numerator * 10 + byte - 48.
		i := i + 1 ].
	negative ifTrue: [ numerator := numerator negated ].
	dotPosition ifNil: [ ^numerator asScaledDecimal: 0 ].
	^ScaledDecimal 
		newFromNumber: (Fraction
			numerator: numerator
			denominator: (10 raisedTo: length - dotPosition)) 
		scale: length - dotPosition
	
]

{ #category : #parsing }
PG3SocketReadStream >> parseStringArrayLength: length [

	^self parseArrayWith: [ self parseStringInArray ] length: length
]

{ #category : #parsing }
PG3SocketReadStream >> parseStringInArray [

	| string |
	self next = 34 ifTrue: [ ^self parseEscapedStringInArray ].
	position := position - 1.
	string := String streamContents: [ :stream |
		| byte |
		[ (byte := self next) 	= 44 or: [ byte = 125 ] ] whileFalse: [
			stream nextPut: (Character value: byte) ] ].
	position := position - 1.
	string = 'NULL' ifTrue: [ ^nil ].
	^textConverter convertToSystemString: string
]

{ #category : #parsing }
PG3SocketReadStream >> parseStringLength: length [

	| byteString bytesAvailable |
	byteString := ByteString basicNew: length.
	length < 14 ifTrue: [ 
		1 to: length do: [ :i |
			byteString basicAt: i put: self next ].
		^textConverter convertToSystemString: byteString ].
	(bytesAvailable := readLimit - position) >= length ifTrue: [ 
		byteString replaceFrom: 1 to: length with: buffer startingAt: position + 1.
		position := position + length.
		^textConverter convertToSystemString: byteString ].
	byteString replaceFrom: 1 to: bytesAvailable with: buffer startingAt: position + 1.
	readLimit := position.
	[ bytesAvailable < length ] whileTrue: [
		bytesAvailable := bytesAvailable + (
			socket 
				waitForData;
				receiveSomeDataInto: byteString startingAt: bytesAvailable + 1) ].
	^textConverter convertToSystemString: byteString
		
]

{ #category : #parsing }
PG3SocketReadStream >> parseTimestampLength: length [
	| string |
	"Offset parsing expects the format [+|-]\d\d:\d\d."
	string := (self next: length) asString.
	string := ('.*[+-]\d\d$' asRegex matches: string)
		ifTrue: [ string, ':00' ]
		ifFalse: [ string ].
	^ DateAndTime fromString: string
]

{ #category : #parsing }
PG3SocketReadStream >> parseXmlArrayLength: length [

	^self parseStringArrayLength: length
]

{ #category : #parsing }
PG3SocketReadStream >> parseXmlLength: length [

	^self parseStringLength: length
]

{ #category : #accessing }
PG3SocketReadStream >> peekUpTo: anInteger [
	| next originalPosition result |
	originalPosition := position.
	result := OrderedCollection new: 5.
	[ position = readLimit or: [ (next := self next) = anInteger ] ] whileFalse: [
		result add: next ].
	self position: originalPosition.
	^ result
]

{ #category : #'accessing-tests' }
PG3SocketReadStream >> position [

	^position
]

{ #category : #'accessing-tests' }
PG3SocketReadStream >> position: anInteger [

	position := anInteger
]

{ #category : #'accessing-tests' }
PG3SocketReadStream >> readLimit: anInteger [

	readLimit := anInteger
]

{ #category : #receiving }
PG3SocketReadStream >> receiveData [

	socket waitForData.
	offset := offset + readLimit.
	readLimit := socket receiveSomeDataInto: buffer startingAt: 1.
	position := 0
]

{ #category : #actions }
PG3SocketReadStream >> resetOffset [

	offset := 0
]

{ #category : #accessing }
PG3SocketReadStream >> socket: aSocket [

	socket := aSocket
]

{ #category : #accessing }
PG3SocketReadStream >> textConverter: aPG3TextConverter [

	textConverter := aPG3TextConverter
]
