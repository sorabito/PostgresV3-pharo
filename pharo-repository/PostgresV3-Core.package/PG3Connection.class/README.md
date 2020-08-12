Example usage:

args := PG3ConnectionArguments new
  hostname: '127.0.0.1';
  port: 5432;
  username: 'fstephany';
  password: '';
  databaseName: 'creative-mons'
  yourself.
 
connection := args newConnection.
connection startup.

rs := connection execute: 'SELECT * FROM entries;'.