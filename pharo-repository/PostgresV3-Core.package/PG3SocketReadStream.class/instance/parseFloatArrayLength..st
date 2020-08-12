parsing
parseFloatArrayLength: length
	^ self
		parseArrayWith: [ self parseNullOr: [
			self parseNextArrayElementWithLength: [ :elementLength |
				self parseFloatLength: elementLength ] ] ]
		length: length