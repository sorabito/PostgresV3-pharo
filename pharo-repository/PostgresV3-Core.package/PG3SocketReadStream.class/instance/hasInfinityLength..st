parsing-private
hasInfinityLength: anInteger
	"possible values are '-infinity' and 'infinity' with lengths 8 and 9"
	^ anInteger
		between: 8
		and: 9