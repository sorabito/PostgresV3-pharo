actions
on: aPG3MessageClass connectionDo: selector goto: aSymbol

	transitions at: aPG3MessageClass put: { (self state: aSymbol). selector }