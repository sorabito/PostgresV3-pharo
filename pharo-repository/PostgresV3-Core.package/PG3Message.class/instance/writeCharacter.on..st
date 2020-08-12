writing
writeCharacter: aCharacter on: aStream

	aStream nextPut: aCharacter asciiValue
	