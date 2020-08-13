Class {
	#name : #BaselineOfPostgresV3,
	#superclass : #BaselineOf,
	#category : #BaselineOfPostgresV3
}

{ #category : #baselines }
BaselineOfPostgresV3 >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec blessing: #release.
			spec
				package: 'PostgresV3-Core'.
			spec
				package: 'PostgresV3-Pool'.
			spec group: 'default' with: #('ALL') ].
]
