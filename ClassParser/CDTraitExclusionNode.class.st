"
MyTrait - {#aliasName}
"
Class {
	#name : #CDTraitExclusionNode,
	#superclass : #CDTraitCompositionNode,
	#instVars : [
		'exclusions'
	],
	#category : #'ClassParser-Model'
}

{ #category : #accessing }
CDTraitExclusionNode >> asCollectionTraitNode [
	^OrderedCollection new add: self subject; yourself.
]

{ #category : #accessing }
CDTraitExclusionNode >> exclusions: aCollection [ 
	exclusions := aCollection
]

{ #category : #testing }
CDTraitExclusionNode >> isTraitExclusionNode [
	
	^ true
]

{ #category : #'as yet unclassified' }
CDTraitExclusionNode >> toString [
	"should replace Exclusions"
	^subject name ,' - ', exclusions asString.
]
