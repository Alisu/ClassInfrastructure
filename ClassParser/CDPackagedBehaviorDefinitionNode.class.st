Class {
	#name : #CDPackagedBehaviorDefinitionNode,
	#superclass : #CDBehaviorDefinitionNode,
	#instVars : [
		'packageNameNode'
	],
	#category : #'ClassParser-Model'
}

{ #category : #accessing }
CDPackagedBehaviorDefinitionNode >> binding [ 
	Transcript show: '.'.
	^ self class environment associationAt: self className ifAbsent: [nil -> self].
]

{ #category : #testing }
CDPackagedBehaviorDefinitionNode >> isClassDefinition [
	
	self flag: #isThisRight. "Trait is a class ?"
	^ true
]

{ #category : #accessing }
CDPackagedBehaviorDefinitionNode >> packageName [
	
	^ packageNameNode ifNotNil: [packageNameNode value asSymbol ]
]

{ #category : #accessing }
CDPackagedBehaviorDefinitionNode >> packageNameNode [
	
	^ packageNameNode
]

{ #category : #accessing }
CDPackagedBehaviorDefinitionNode >> packageNameNode: aNode astNode: astNode [

	packageNameNode := aNode.
	children add: aNode.
]
