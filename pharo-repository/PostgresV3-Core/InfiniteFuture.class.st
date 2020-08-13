Class {
	#name : #InfiniteFuture,
	#superclass : #DateAndTime,
	#category : #'PostgresV3-Core'
}

{ #category : #'instance creation' }
InfiniteFuture class >> new [
	^ self julianDayNumber: SmallInteger maxVal
]

{ #category : #printing }
InfiniteFuture >> pg3PrintAsLiteralOn: stream [
	stream
		nextPutAll: 'timestamp ''';
		nextPutAll: 'infinity';
		nextPut: $'
]
