"
I supposed to be the fast UTF-8 text converter between Postgres and Squeak. I should be benchmarked again, since Squeak's UTF8TextConverter became a lot faster in 4.1.
"
Class {
	#name : #PG3UTF8TextConverter,
	#superclass : #PG3TextConverter,
	#category : #'PostgresV3-Core'
}

{ #category : #conversion }
PG3UTF8TextConverter >> convertFromSqueak: aString from: indexOfNonAsciiCharacter [
	
	| resultStream buffer |
	buffer := (ByteString new: aString size + 1)
		replaceFrom: 1 to: indexOfNonAsciiCharacter - 1with: aString startingAt: 1;
		yourself.
	resultStream := (WriteStream on: buffer)
		setFrom: indexOfNonAsciiCharacter to: buffer size;
		yourself.
	indexOfNonAsciiCharacter to: aString size do: [ :index |
		| character byteCount mask shift |
		(character := aString at: index) asciiValue < 128
			ifTrue: [ resultStream nextPut: character ]
			ifFalse: [ 
				| characterCode |
				characterCode := character charCode.
				byteCount := characterCode highBit + 3 // 5.
				mask := #(128 192 224 240) at: byteCount.
				shift := 1 - byteCount * 6.
				resultStream nextPut: (Character value: (characterCode bitShift: shift) + mask).
				2 to: byteCount do: [ :byteIndex |
					resultStream nextPut: (
						Character value: (
							(characterCode bitShift: (shift := shift + 6)) bitAnd: 63) + 128) ] ] ].
	resultStream position = aString size
		ifTrue: [ ^resultStream originalContents ].
	^resultStream contents
]

{ #category : #conversion }
PG3UTF8TextConverter >> convertFromSystemString: aString [

	1 to: aString size do: [ :indexOfNonAsciiCharacter |
		(aString at: indexOfNonAsciiCharacter) asciiValue > 127 ifTrue: [
			^self convertFromSqueak: aString from: indexOfNonAsciiCharacter ] ].
	^aString
]

{ #category : #conversion }
PG3UTF8TextConverter >> convertToSqueak: aByteString from: indexOfNonAsciiCharacter [
	
	| index resultStream buffer |
	buffer := (String new: aByteString size - 1)
		replaceFrom: 1 to: indexOfNonAsciiCharacter - 1 with: aByteString startingAt: 1;
		yourself.
	resultStream := (WriteStream on: buffer)
		setFrom: indexOfNonAsciiCharacter to: buffer size;
		yourself.
	index := indexOfNonAsciiCharacter.
	[ index <= aByteString size ] whileTrue: [ 
		| byte1 |
		(byte1 := aByteString basicAt: index) < 128
			ifTrue: [ resultStream nextPut: (aByteString at: index) ]
			ifFalse: [
				| byte2 |
				byte2 := aByteString basicAt: (index := index + 1).
				byte1 < 224
					ifTrue: [ resultStream nextPut: (
						Character value: ((byte1 bitAnd: 31) bitShift: 6) + (byte2 bitAnd: 63)) ]
					ifFalse: [
						| byte3 |
						byte3 := aByteString basicAt: (index := index + 1).
						byte1 < 240
							ifTrue: [ resultStream nextPut: (
								Character value: ((byte1 bitAnd: 15) bitShift: 12) + 
									((byte2 bitAnd: 63) bitShift: 6) + (byte3 bitAnd: 63)) ]
							ifFalse: [
								| byte4 |
								byte4 := aByteString basicAt: (index := index + 1).
								resultStream nextPut: (
									Character value: ((byte1 bitAnd: 16r7) bitShift: 18) +
										((byte2 bitAnd: 63) bitShift: 12) + 
										((byte3 bitAnd: 63) bitShift: 6) +
										(byte4 bitAnd: 63)) ] ] ].
		index := index + 1 ].
	resultStream position = aByteString size
		ifTrue: [ ^resultStream originalContents ].
	^resultStream contents
]

{ #category : #conversion }
PG3UTF8TextConverter >> convertToSystemString: aByteString [

	1 to: aByteString size do: [ :indexOfNonAsciiCharacter |
		(aByteString at: indexOfNonAsciiCharacter) asciiValue > 127 ifTrue: [
			^self convertToSqueak: aByteString from: indexOfNonAsciiCharacter ] ].
	^aByteString
]
