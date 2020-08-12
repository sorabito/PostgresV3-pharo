dispatching
dispatchFrom: stream connection: connection

	^(DispatcherArray at: stream next) readFrom: stream connection: connection