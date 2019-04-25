"
I represent a simple Trait. (no composition, alias, exclusion)
"
Class {
	#name : #CDTraitNode,
	#superclass : #CDAbstractTraitCompositionNode,
	#instVars : [
		'name'
	],
	#category : #'ClassParser-Model'
}

{ #category : #converting }
CDTraitNode >> asCollectionTraitNode [

	^OrderedCollection new add: self; yourself.
]

{ #category : #testing }
CDTraitNode >> isTraitNode [

	^ true
]

{ #category : #accessing }
CDTraitNode >> name [
	^name 
]

{ #category : #accessing }
CDTraitNode >> name: aString [ 
	name := aString
]

{ #category : #'as yet unclassified' }
CDTraitNode >> toString [ 
	^self name
]
