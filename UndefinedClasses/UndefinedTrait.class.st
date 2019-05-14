"
I am supposed to be a stub for trait.

Should i have users ?
"
Class {
	#name : #UndefinedTrait,
	#superclass : #Trait,
	#category : #'UndefinedClasses-Trait'
}

{ #category : #'instance creation' }
UndefinedTrait class >> named: aSymbol [
	^ self named: aSymbol uses: {} slots: {} category: 'Unclassified' env: self environment .

]

{ #category : #'instance creation' }
UndefinedTrait class >> named: aName uses: aTraitCompositionOrCollection slots: someSlots category: aCategory env: anEnvironment [ 

	| trait |
	trait:= self classInstaller
		make: [ :builder | 
			builder
				name: aName;
				superclass: nil;
				metaSuperclass: self;
				slots: someSlots;
				sharedVariables: '';
				sharedPools: '';
				category: aCategory;
				traitComposition: aTraitCompositionOrCollection asTraitComposition;
				classTraitComposition: aTraitCompositionOrCollection asTraitComposition classComposition;
				classSlots: #(). ].
			
	"self assert: [ trait class class = MetaclassForTraits ]."
	self assert: [ trait class superclass = UndefinedTrait ].
	
	^ trait
]

{ #category : #accessing }
UndefinedTrait >> isUndefined [
	^true
]
