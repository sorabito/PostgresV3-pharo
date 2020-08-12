accessing
stateGraphDescription

	self 
		authenticatingStateDescription;
		authenticatingWithMD5StateDescription;
		authenticatingWithCleartextStateDescription;
		initializingBackendStateDescription;
		waitingForQuery;
		querying;
		gotCommandComplete;
		gotRowDescription;
		gotDataRow;
		gotEmptyQueryResponse;
		gotErrorResponseDuringSimpleQuery
	