Subclasses of this class represents the different authentication schemes supported by PG. The authentication type will be sent by the server. The client then should act accordingly.

If the authentication is successful, the server will send a PG3AuthenticationOkMessage. 
If it is not, PG3ErrorResponse will be sent and the connection will be closed.

Each subclass class comment contains the official PG documentation description.

See http://www.postgresql.org/docs/9.4/static/protocol-flow.html#AEN102761 