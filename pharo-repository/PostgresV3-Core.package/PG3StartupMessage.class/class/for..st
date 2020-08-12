instance creation
for: connection

	| arguments |
	arguments := connection arguments.
	^self new
		addParameter: 'user' value: arguments username;
		addParameter: 'database' value: arguments databaseName;
		yourself