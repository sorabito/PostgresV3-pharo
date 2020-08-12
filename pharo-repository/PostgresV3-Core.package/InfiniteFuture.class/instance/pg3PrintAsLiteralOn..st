printing
pg3PrintAsLiteralOn: stream
	stream
		nextPutAll: 'timestamp ''';
		nextPutAll: 'infinity';
		nextPut: $'