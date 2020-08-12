extended-query-protocol
execute: queryString withArguments: argumentsCollection
	" 1. Send PARSE
	  2. BIND the parameters
	  3. Execute.
	  4. Profit
	"
	
