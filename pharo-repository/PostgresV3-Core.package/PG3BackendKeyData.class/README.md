Sent by the server after a successful authentication (See  PG3AuthenticationOkMessage).

This message provides secret-key data that the frontend must save if it wants to be able to issue cancel requests later. The frontend should not respond to this message, but should continue listening for a ReadyForQuery message.
