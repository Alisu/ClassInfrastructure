Extension { #name : #ShiftClassBuilder }

{ #category : #'*ClassParser' }
ShiftClassBuilder >> buildFromAST: aCDClassDefinitionNode [

	| package trait|

	self name: aCDClassDefinitionNode className.
	
	aCDClassDefinitionNode superclassName = #nil
		ifFalse: [ self
				superclass:
					(superclassResolver
						resolve: aCDClassDefinitionNode superclassName
						inEnv: buildEnvironment) ]
		ifTrue: [ self superclass: nil ].
		
	self layoutClass: FixedLayout.
	aCDClassDefinitionNode isEphemeron
		ifTrue: [ self layoutClass: EphemeronLayout ].
	aCDClassDefinitionNode isWeak
		ifTrue: [ self layoutClass: WeakLayout ].
	aCDClassDefinitionNode isImmediate
		ifTrue: [ self layoutClass: ImmediateLayout ].
	aCDClassDefinitionNode isVariable
		ifTrue: [ self layoutClass: VariableLayout ].
	aCDClassDefinitionNode isWords
		ifTrue: [ self layoutClass: WordLayout ].
	aCDClassDefinitionNode isBytes
		ifTrue: [ self layoutClass: ByteLayout ].
		
	self slots: (aCDClassDefinitionNode slots collect: [ :e | e asSlot ]).
	
	self sharedVariables: (aCDClassDefinitionNode sharedSlots collect: [ :e | e ]).
	
	aCDClassDefinitionNode packageName
		ifNotNil: [ :cat | package := cat ]
		ifNil: [ package := 'Unclassified' ].
	self category: package.
	
	self layoutDefinition sharedPools: (aCDClassDefinitionNode sharedPools collect: [ :e | e name ]).
	
	self flag: #TODO ."Have a resolver with strategies instead of self error"
	aCDClassDefinitionNode traitDefinition
		ifNotNil: [ :traitDef | 
					trait := (self class compiler
						source: traitDef originalNode formattedCode;
						environment: self environment;
							evaluate).
					trait isNil
					ifTrue:[self inform: 'Trait not defined']
					ifFalse:[self traitComposition: trait].
							 ]
]
