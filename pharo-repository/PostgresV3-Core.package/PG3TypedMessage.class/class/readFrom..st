instance creation
readFrom: stream

	^self new
		length: stream nextInt32 - 4;
		readFrom: stream;
		yourself