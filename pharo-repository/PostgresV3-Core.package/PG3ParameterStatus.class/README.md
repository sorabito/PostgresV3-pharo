Sent by the server after a successful authentication (See  PG3AuthenticationOkMessage).

This message informs the frontend about the current (initial) setting of backend parameters, such as client_encoding or DateStyle. The frontend can ignore this message, or record the settings for its future use; see Section 49.2.6 for more details. The frontend should not respond to this message, but should continue listening for a ReadyForQuery message.

Section 49.2.6: http://www.postgresql.org/docs/9.4/static/protocol-flow.html#PROTOCOL-ASYNC