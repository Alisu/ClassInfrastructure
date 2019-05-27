Class {
	#name : #UndefinedTraitBuilderEnhancer,
	#superclass : #ShDefaultBuilderEnhancer,
	#instVars : [
		'builder'
	],
	#category : #'TraitsV2-Class-Builder'
}

{ #category : #testing }
UndefinedTraitBuilderEnhancer class >> isApplicableFor: aBuilder [

	aBuilder metaSuperclass = UndefinedTrait ifTrue: [ ^ true ].
	aBuilder oldClass class superclass = UndefinedTrait ifTrue: [ ^ true ].
	
	"aBuilder oldClass class class = TraitedMetaclass ifTrue: [ ^ true ].
	aBuilder superclass class class = TraitedMetaclass ifTrue: [ ^ true ]."

		(aBuilder traitComposition asTraitComposition isNotEmpty and: [aBuilder traitComposition isUndefined] )ifTrue: [ ^ true ].
	(aBuilder classTraitComposition asTraitComposition isNotEmpty and: [aBuilder classTraitComposition isUndefined] ) ifTrue: [ ^ true ].

	^ false
]

{ #category : #'class modifications' }
UndefinedTraitBuilderEnhancer >> afterMethodsCompiled: aBuilder [

	(self isTraitedMetaclass: aBuilder)
		ifFalse: [ ^ self ].

	builder newMetaclass rebuildMethodDictionary.
	aBuilder newClass rebuildMethodDictionary.
]

{ #category : #migrating }
UndefinedTraitBuilderEnhancer >> afterMigratingClass: aBuilder installer: anInstaller [

	(self isTraitedMetaclass: aBuilder)
		ifFalse: [ ^ self ].

	aBuilder newClass traitComposition addUser: aBuilder newClass.
	aBuilder newMetaclass traitComposition addUser: aBuilder newMetaclass.
	
	UndefinedTraitedClass addUser: aBuilder newMetaclass.
	
	"If this is a trait I have to update the users"
	aBuilder newClass isTrait ifFalse: [ ^ self ].
	
	builder newMetaclass traitUsers do: [:e | e rebuildMethodDictionary].
	aBuilder newClass traitUsers do: [:e | e rebuildMethodDictionary].
]

{ #category : #migrating }
UndefinedTraitBuilderEnhancer >> beforeMigratingClass: aBuilder installer: anInstaller [
	aBuilder oldClass ifNil: [ ^ self ].
	
	aBuilder oldClass traitComposition removeUser: aBuilder oldClass.
	aBuilder oldMetaclass traitComposition removeUser: aBuilder oldMetaclass.
	
	UndefinedTraitedClass removeUser: aBuilder oldMetaclass.	
	
	"If it is a Trait we should migrate the users "
	aBuilder newClass isTrait ifFalse: [ ^ self ].	
	aBuilder newClass users: aBuilder oldClass users.
	aBuilder newMetaclass users: aBuilder oldMetaclass users.	
	
]

{ #category : #events }
UndefinedTraitBuilderEnhancer >> classCreated: aBuilder [

	(self isTraitedMetaclass: aBuilder)
		ifFalse: [ ^ self ].

	builder newMetaclass initializeBasicMethods.
	
	builder newClass traitComposition: self traitComposition.
	builder newMetaclass traitComposition: self classTraitComposition.

]

{ #category : #accessing }
UndefinedTraitBuilderEnhancer >> classTraitComposition [
	^ builder classTraitComposition asTraitComposition
]

{ #category : #accessing }
UndefinedTraitBuilderEnhancer >> classTraitCompositionOf: aBuilder [ 
	
	^ aBuilder classTraitComposition asTraitComposition
]

{ #category : #utilities }
UndefinedTraitBuilderEnhancer >> classTraitCompositionOfClass: aClass [ 
	
	^ aClass class traitComposition asTraitComposition
]

{ #category : #'class modifications' }
UndefinedTraitBuilderEnhancer >> configureClass: newClass superclass: superclass withLayoutType: layoutType slots: slots [
	| resultingSlots |
	self validateTraitComposition: self traitComposition ofClass: builder oldClass.

	resultingSlots := self
		eliminateDuplicates: slots , self traitComposition slotsCopy
		withSuperclassSlots: (superclass ifNil: [#()] ifNotNil:[ :x | x allSlots]).

	newClass superclass: superclass withLayoutType: layoutType slots: resultingSlots
]

{ #category : #'class modifications' }
UndefinedTraitBuilderEnhancer >> configureMetaclass: newMetaclass superclass: superclass withLayoutType: aLayoutType slots: classSlots [
	| resultingSlots |

	self validateTraitComposition: self classTraitComposition ofClass: builder oldMetaclass.

	resultingSlots := self
		eliminateDuplicates: classSlots , self classTraitComposition slotsCopy
		withSuperclassSlots: superclass allSlots.

	newMetaclass superclass: superclass withLayoutType: aLayoutType slots: resultingSlots
]

{ #category : #utilities }
UndefinedTraitBuilderEnhancer >> eliminateDuplicates: aSlotCollection withSuperclassSlots: superclassSlots [
	| resultingSlots |
	resultingSlots := OrderedCollection new.

	aSlotCollection
		do: [ :e | 
			((resultingSlots noneSatisfy: [ :x | e name = x name ]) and: [ superclassSlots noneSatisfy: [ :x | e name = x name ] ])
				ifTrue: [ resultingSlots add: e ] ].


	^ resultingSlots asArray
]

{ #category : #initialization }
UndefinedTraitBuilderEnhancer >> fillBuilder: aBuilder from: aClass [ 
	
	(aBuilder superclass isNil and: [ aClass superclass isNil ]) 
		ifTrue: [ aBuilder metaSuperclass: aClass class superclass ].
	
	aBuilder traitComposition: aClass traitComposition.
	aBuilder classTraitComposition: aClass class traitComposition.

]

{ #category : #migrating }
UndefinedTraitBuilderEnhancer >> hasToSkipSlot: aSlot [
	^ Class hasSlotNamed: aSlot name
]

{ #category : #initialization }
UndefinedTraitBuilderEnhancer >> initializeBuilder: aBuilder [
	super initializeBuilder: aBuilder.

	builder := aBuilder.

	aBuilder addChangeComparer: TraitCompositionChangedDetector.
]

{ #category : #testing }
UndefinedTraitBuilderEnhancer >> isTraitedMetaclass: aBuilder [ 
	
	^ aBuilder metaclassClass includesBehavior: TraitedMetaclass
	
]

{ #category : #'class modifications' }
UndefinedTraitBuilderEnhancer >> newMetaclass: aBuilder [

	(aBuilder traitComposition asTraitComposition isNotEmpty or: [ aBuilder classTraitComposition asTraitComposition isNotEmpty or: [ aBuilder superclass class class = TraitedMetaclass]])
		ifTrue: [ aBuilder metaclassClass: TraitedMetaclass ].
				
	aBuilder metaSuperclass = UndefinedTrait
		ifTrue: [ aBuilder metaclassClass: MetaclassForTraits ].		
		
	^ (super newMetaclass: aBuilder)
		traitedClass: UndefinedTraitedClass;
		yourself
]

{ #category : #'class modifications' }
UndefinedTraitBuilderEnhancer >> propagateChangesToRelatedClasses: newClass installer: installer [

	super propagateChangesToRelatedClasses: newClass installer: installer.

	"If the newClass is a trait I have to remake the users of it"
	newClass isTrait ifFalse: [ ^ self ].
	(builder changes noneSatisfy: 
		[ :each | each hasChangeClassSideShape or: [ each hasChangeInstanceSideShape  ] ]) 
		ifTrue: [^self].

	newClass users do: [ :each | installer remake: each instanceSide ]
]

{ #category : #accessing }
UndefinedTraitBuilderEnhancer >> traitComposition [
	^ builder traitComposition asTraitComposition
]

{ #category : #accessing }
UndefinedTraitBuilderEnhancer >> traitCompositionOf: aBuilder [ 
	
	^ aBuilder traitComposition asTraitComposition
]

{ #category : #utilities }
UndefinedTraitBuilderEnhancer >> traitCompositionOfClass: aClass [ 
	
	^ aClass traitComposition asTraitComposition
]

{ #category : #validating }
UndefinedTraitBuilderEnhancer >> validateTraitComposition: aTraitComposition ofClass: aClass [ 

	^ (aTraitComposition allTraits includes: aClass) ifTrue: [ self error: 'Cyclic Trait composition' ]
]
