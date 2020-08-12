protocols-startup
authenticatingWithCleartextStateDescription

	(self state: #AuthenticatingWithCleartext)
		on: PG3AuthenticationOkMessage goto: #InitializingBackend