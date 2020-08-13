Extension { #name : #ScaledDecimal }

{ #category : #'*PostgresV3-Core' }
ScaledDecimal >> pg3PrintAsLiteralOn: stream [
	self printOn: stream showingDecimalPlaces: scale
]
