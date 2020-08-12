parsing
parseScaledDecimalArrayLength: length
	^ self
		parseArrayWith: [ self parseNullOr: [
			self parseNextArrayElementWithLength: [ :elementLength |
				self parseScaledDecimalLength: elementLength ] ] ]
		length: length