Class {
	#name : #UndefinedTraitTest,
	#superclass : #TestCase,
	#instVars : [
		'undefTrait'
	],
	#category : #'UndefinedClasses-Tests'
}

{ #category : #running }
UndefinedTraitTest >> setUp [
	
	super setUp.
	
 	undefTrait := UndefinedTrait named: #TTest.
]

{ #category : #running }
UndefinedTraitTest >> tearDown [ 
	
	self class environment at: #TTest ifPresent: [ :c | c removeFromSystem ].
	super tearDown.
	
]

{ #category : #tests }
UndefinedTraitTest >> testCreateTwoUndefinedTraitOfSameNameShouldBeSameTrait [

	| tfoo |
	
	tfoo := UndefinedTrait named: #TTest.
	
	self assert: tfoo == undefTrait
]

{ #category : #tests }
UndefinedTraitTest >> testDefinedTraitIsNotUndefined [

	self deny: Object isUndefined
]

{ #category : #tests }
UndefinedTraitTest >> testMetaclassOfUndefinedTraitIsUndefined [

	self assert: undefTrait class isDefined.
]

{ #category : #tests }
UndefinedTraitTest >> testRemoveUndefinedTraitShouldRemoveIt [
		
		|name|
		name := undefTrait name.
		undefTrait removeFromSystem.
		
	self assert: (self class environment at: name ifAbsent: [ true ])
]

{ #category : #tests }
UndefinedTraitTest >> testUndefinedTraitClassClassIsMetaclassForTrait [

	self assert: undefTrait isTrait.
	self assert: undefTrait class class equals: (self class environment classNamed: #MetaclassForTraits).

]

{ #category : #tests }
UndefinedTraitTest >> testUndefinedTraitClassSuperClassIsUndefinedTrait [

	self assert: undefTrait isTrait.
	self assert: undefTrait class superclass equals: (self class environment classNamed: #UndefinedTrait).

]

{ #category : #tests }
UndefinedTraitTest >> testUndefinedTraitIsUndefined [
	self assert: undefTrait isTrait.
	self assert: undefTrait isUndefined.
]
