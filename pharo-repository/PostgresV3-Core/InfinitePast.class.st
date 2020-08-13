Class {
	#name : #InfinitePast,
	#superclass : #DateAndTime,
	#category : #'PostgresV3-Core'
}

{ #category : #'instance creation' }
InfinitePast class >> new [
	^ self julianDayNumber: SmallInteger maxVal negated
]

{ #category : #printing }
InfinitePast >> pg3PrintAsLiteralOn: stream [
	stream
		nextPutAll: 'timestamp ''';
		nextPutAll: '-infinity';
		nextPut: $'
]
