initialize-release
readFrom: stream
	
	processId := stream nextInt32.
	secretKey := stream nextInt32