Class {
	#name : #TraitUsingUndefinedTraitTest,
	#superclass : #UndefinedTraitTest,
	#category : #'UndefinedClasses-Tests'
}

{ #category : #running }
TraitUsingUndefinedTraitTest >> setUp [
	
	super setUp.
	
 	undefTrait := UndefinedTrait named: #TTest.

]

{ #category : #running }
TraitUsingUndefinedTraitTest >> tearDown [ 
	
	self class environment at: #TTest2 ifPresent: [ :c | c removeFromSystem ].
	super tearDown.
	
]

{ #category : #tests }
TraitUsingUndefinedTraitTest >> testTraitUsingUndefineTraitAlias [
	
	| traitedTrait |
	traitedTrait := Trait
		named: #TTest2
		uses: undefTrait @ {(#methodAlias -> #aliasedMethod)}.
	self assertMetaclassClassIsMetaclassForTrait: traitedTrait.

]

{ #category : #tests }
TraitUsingUndefinedTraitTest >> testTraitUsingUndefineTraitRejectMethods [
	
	| traitedTrait |
	traitedTrait := Trait
		named: #TTest2
		uses: undefTrait - {#testIfNotEmptyifEmpty . #testIfEmpty . #testNotEmpty}.
	self assertMetaclassClassIsMetaclassForTrait: traitedTrait.

]

{ #category : #tests }
TraitUsingUndefinedTraitTest >> testTraitWithUndefinedTrait [

	| traitedTrait |
	traitedTrait := Trait named: #TTest2 uses: undefTrait.
	self assertMetaclassClassIsMetaclassForTrait: traitedTrait.


]

{ #category : #tests }
TraitUsingUndefinedTraitTest >> testTraitWithUndefinedTraitSequence [
	
	| traitedTrait |
	traitedTrait := Trait
		named: #TTest2
		uses: undefTrait + self aDefinedTrait.	
	self assertMetaclassClassIsMetaclassForTrait: traitedTrait.

]
