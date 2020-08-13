Extension { #name : #Date }

{ #category : #'*PostgresV3-Core' }
Date >> pg3PrintAsLiteralOn: stream [

	self dayMonthYearDo: [ :day :month :year |
		stream 
			nextPut: $';
			print: year;
			nextPut: $-;
			print: month;
			nextPut: $-;
			print: day;
			nextPutAll: '''::date' ]
]
