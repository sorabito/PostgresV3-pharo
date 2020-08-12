Usage:

A connection pool is a singleton, so create a subclass of
PG3ConnectionPool:

PG3ConnectionPool subclass: #PG3ExampleConnectionPool
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Postgres-Example'

Implement #defaultConnectionArguments on the class side:

defaultConnectionArguments
	^PG3ConnectionArguments new
		hostname: '127.0.0.1';
		port: 5432;
		username: 'user1';
		password: '123';
		databaseName: 'foo';
		yourself.

Then you can use your connection pool using the following;

PG3ExampleConnectionPool default withConnectionDo: [ :connection |
	connection execute: 'select 3 + 4'.
	connection execute: 'select now()' ]. 