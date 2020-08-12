parsing
parseTimestampLength: length
	| string |
	"Offset parsing expects the format [+|-]\d\d:\d\d."
	string := (self next: length) asString.
	string := ('.*[+-]\d\d$' asRegex matches: string)
		ifTrue: [ string, ':00' ]
		ifFalse: [ string ].
	^ DateAndTime fromString: string