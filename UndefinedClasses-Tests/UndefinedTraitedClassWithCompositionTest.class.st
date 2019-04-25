Class {
	#name : #UndefinedTraitedClassWithCompositionTest,
	#superclass : #UndefinedTraitTest,
	#instVars : [
		'traitedClass'
	],
	#category : #'UndefinedClasses-Tests'
}

{ #category : #'as yet unclassified' }
UndefinedTraitedClassWithCompositionTest >> aDefinedTrait [
	^TAssertable 
]

{ #category : #running }
UndefinedTraitedClassWithCompositionTest >> setUp [
	
	super setUp.
	
 	undefTrait := UndefinedTrait named: #TTest.
	traitedClass := Object subclass: #SomeTraitedClass
								  uses: undefTrait + TAssertable.
]

{ #category : #running }
UndefinedTraitedClassWithCompositionTest >> tearDown [ 
	
	self class environment at: #SomeTraitedClass ifPresent: [ :c | c removeFromSystem ].
	super tearDown.
	
]

{ #category : #tests }
UndefinedTraitedClassWithCompositionTest >> testClassWithUndefinedTraitCannotBeInstantiate [
"It means the basic new in the class side is redefine"

	self should: [traitedClass new] raise: Error.
]

{ #category : #tests }
UndefinedTraitedClassWithCompositionTest >> testClassWithUndefinedTraitClassClassIsTraitedMetaclass [
 	
	self assert: traitedClass class class equals: TraitedMetaclass.

]

{ #category : #tests }
UndefinedTraitedClassWithCompositionTest >> testRedefineClassWithUndefinedTraitClassClassIsTraitedMetaclass [
 	
	"We assert that there was something before"
	| undefTrait2 |
	self assert: (self class environment hasClassNamed: #SomeTraitedClass).
	self assert: (traitedClass class baseComposition traits includes: self aDefinedTrait).

	"We redefine the existing and try to use 2 undefinedTrait"
	undefTrait2 := UndefinedTrait named: #TTest2.
	traitedClass := Object subclass: #SomeTraitedClass
								  uses: undefTrait + undefTrait2.
								
	"We assert that the redefinition happened"
	self assert: (self class environment hasClassNamed: #SomeTraitedClass).
	self assert: (traitedClass class baseComposition traits includes: undefTrait2).

	self assert: traitedClass class class equals: TraitedMetaclass.
	
	undefTrait2 removeFromSystem.
]

{ #category : #tests }
UndefinedTraitedClassWithCompositionTest >> testTraitWithMoreComplexUndefinedTraitComposition [
		
		| traitedTrait |
	traitedTrait := Trait named: #TTest2
								  uses: TAddForUniquenessTest + undefTrait + TCloneTest + TCopyTest + TRemoveTest + TGrowableTest + TStructuralEqualityTest + TPrintTest + TAsStringCommaAndDelimiterTest + TConvertTest + TConvertAsSortedTest + TConcatenationEqualElementsRemovedTest + TOccurrencesTest + (TCreationWithTest - {#testOfSize. #collectionClass}) + (TSetArithmetic - {#collectionClass}).
								
	self assert: traitedTrait class class equals: MetaclassForTraits.
								
	traitedTrait removeFromSystem.
]

{ #category : #tests }
UndefinedTraitedClassWithCompositionTest >> testTraitWithUndefinedTraitComposition [
		| traitedTrait |
	traitedTrait := Trait named: #TTest2
								  uses: undefTrait + self aDefinedTrait.
								
	self assert: traitedTrait class class equals: MetaclassForTraits.
								
	traitedTrait removeFromSystem.
]
