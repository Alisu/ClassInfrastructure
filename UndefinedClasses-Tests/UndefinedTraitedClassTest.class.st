Class {
	#name : #UndefinedTraitedClassTest,
	#superclass : #UndefinedTraitTest,
	#instVars : [
		'traitedClass'
	],
	#category : #'UndefinedClasses-Tests'
}

{ #category : #running }
UndefinedTraitedClassTest >> setUp [
	
	super setUp.
	
 	undefTrait := UndefinedTrait named: #TTest.
	traitedClass := Object subclass: #SomeTraitedClass
								  uses: undefTrait.
]

{ #category : #running }
UndefinedTraitedClassTest >> tearDown [ 
	
	self class environment at: #SomeTraitedClass ifPresent: [ :c | c removeFromSystem ].
	super tearDown.
	
]

{ #category : #tests }
UndefinedTraitedClassTest >> testClassWithUndefinedTraitAndRemoveMethods [

	traitedClass := Object subclass: #SomeTraitedClass
								  uses: undefTrait - {#testIfNotEmptyifEmpty. #testIfEmpty. #testNotEmpty}.
 	
	self assert: traitedClass class class equals: TraitedMetaclass.

]

{ #category : #tests }
UndefinedTraitedClassTest >> testClassWithUndefinedTraitCannotBeInstantiate [
"It means the basic new in the class side is redefine"

	self should: [traitedClass new] raise: Error.
]

{ #category : #tests }
UndefinedTraitedClassTest >> testClassWithUndefinedTraitClassClassIsTraitedMetaclass [
 	
	self assert: traitedClass class class equals: TraitedMetaclass.

]

{ #category : #tests }
UndefinedTraitedClassTest >> testRedefineClassWithUndefinedTraitClassClassIsTraitedMetaclass [
 	
	"We assert that there was something before"
	self assert: (self class environment hasClassNamed: #SomeTraitedClass).
	self assert: (traitedClass class baseComposition traits includes: undefTrait).
	
	"We redefine the existing"
	undefTrait := UndefinedTrait named: #TTest2.
	traitedClass := Object subclass: #SomeTraitedClass
								  uses: undefTrait.
	
	"We assert that the redefinition happened"
	self assert: (self class environment hasClassNamed: #SomeTraitedClass).
	self assert: (traitedClass class baseComposition traits includes: undefTrait).

	self assert: traitedClass class class equals: TraitedMetaclass.
	
	undefTrait removeFromSystem.


]

{ #category : #tests }
UndefinedTraitedClassTest >> testTraitWithUndefinedTrait [
		| traitedTrait |
	traitedTrait := Trait named: #TTest2
								  uses: undefTrait.
								
	self assert: traitedClass class class equals: TraitedMetaclass.
								
	traitedTrait removeFromSystem.
]
