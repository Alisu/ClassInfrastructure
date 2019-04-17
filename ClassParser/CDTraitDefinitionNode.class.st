Class {
	#name : #CDTraitDefinitionNode,
	#superclass : #CDPackagedBehaviorDefinitionNode,
	#category : #'ClassParser-Model'
}

{ #category : #testing }
CDTraitDefinitionNode >> isClassDefinition [
	
	self flag: #isThisRight. "Trait is a class ?"
	^ false
]

{ #category : #testing }
CDTraitDefinitionNode >> isTraitDefinition [
	
	^ true
]
