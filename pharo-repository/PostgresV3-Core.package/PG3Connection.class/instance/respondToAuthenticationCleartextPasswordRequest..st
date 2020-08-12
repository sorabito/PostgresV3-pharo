startup-protocol
respondToAuthenticationCleartextPasswordRequest: message
	self sendMessage: (
		PG3PasswordMessage new
			password: arguments password ;
			yourself) 