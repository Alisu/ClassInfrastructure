"
This class contains tests for class using UndefinedTrait.
UndefinedTrait should not have instance variable.
"
Class {
	#name : #UndefinedTraitedClassTest,
	#superclass : #UndefinedTraitTest,
	#instVars : [
		'traitedClass'
	],
	#category : #'UndefinedClasses-Tests'
}

{ #category : #'as yet unclassified' }
UndefinedTraitedClassTest >> assertMetaclassClassIsTraitedMetaclass: aClass [
	^self assert: aClass class class equals: TraitedMetaclass
]

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
UndefinedTraitedClassTest >> testClassWithCompleteUndefinedTraitSequence [
	
	| undefTrait2 |
	"We redefine the existing and try to use 2 undefinedTrait"
	undefTrait2 := UndefinedTrait named: #TTest2.
	traitedClass := Object
		subclass: #SomeTraitedClass
		uses: undefTrait + undefTrait2.

	"We assert that the redefinition happened"
	self
		assert: (self class environment hasClassNamed: #SomeTraitedClass).
	self
		assert: (traitedClass class baseComposition traits includes: undefTrait).
	self assertMetaclassClassIsTraitedMetaclass: traitedClass
]

{ #category : #tests }
UndefinedTraitedClassTest >> testClassWithPartialUndefinedTraitSequence [
	
	| undefTrait2 |
	"We redefine the existing and try to use 2 undefinedTrait"
	undefTrait2 := UndefinedTrait named: #TTest2.
	traitedClass := Object
		subclass: #SomeTraitedClass
		uses: undefTrait + self aDefinedTrait.

	"We assert that the redefinition happened"
	self
		assert: (self class environment hasClassNamed: #SomeTraitedClass).
	self
		assert: (traitedClass class baseComposition traits includes: undefTrait).
	self assertMetaclassClassIsTraitedMetaclass: traitedClass
]

{ #category : #tests }
UndefinedTraitedClassTest >> testClassWithUndefinedTraitAlias [
	
	| undefTrait2 |
	"We redefine the existing and try to use 2 undefinedTrait"
	undefTrait2 := UndefinedTrait named: #TTest2.
	traitedClass := Object
		subclass: #SomeTraitedClass
		uses: undefTrait2 @ {(#methodAlias -> #aliasedMethod)}.

	"We assert that the redefinition happened"
	self
		assert: (self class environment hasClassNamed: #SomeTraitedClass).
	self
		assert: (traitedClass class baseComposition traits includes: undefTrait2).
	self assertMetaclassClassIsTraitedMetaclass: traitedClass
]

{ #category : #tests }
UndefinedTraitedClassTest >> testClassWithUndefinedTraitAliasInstVar [
	
	| undefTrait2 |
	"We redefine the existing and try to use 2 undefinedTrait"
	undefTrait2 := UndefinedTrait named: #TTest2.
	traitedClass := Object
		subclass: #SomeTraitedClass
		uses: (undefTrait2 asTraitComposition >> (#instVarAlias -> #aliasedInstVar)).

	"We assert that the redefinition happened"
	self
		assert: (self class environment hasClassNamed: #SomeTraitedClass).
	self
		assert: (traitedClass class baseComposition traits includes: undefTrait2).
	self assertMetaclassClassIsTraitedMetaclass: traitedClass
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
UndefinedTraitedClassTest >> testClassWithUndefinedTraitRejectInstVar [
	
	| undefTrait2 |
	"We redefine the existing and try to use 2 undefinedTrait"
	undefTrait2 := UndefinedTrait named: #TTest2.
	traitedClass := Object
		subclass: #SomeTraitedClass
		uses: (undefTrait2 asTraitComposition  -- #instVarNameToRemove).

	"We assert that the redefinition happened"
	self
		assert: (self class environment hasClassNamed: #SomeTraitedClass).
	self
		assert: (traitedClass class baseComposition traits includes: undefTrait2).
	self assertMetaclassClassIsTraitedMetaclass: traitedClass
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
