"
! Playground pages (StPlaygroundPage)

A playground page keeps in sync what is being typed into a playground and the disk cache.
Pages are stored (by default) at ==StPlayground cacheDirectory== and have a timestamp as name.

@@TODO complete
"
Class {
	#name : #StPlaygroundPage,
	#superclass : #Object,
	#instVars : [
		'creationTime',
		'fileName',
		'mutex',
		'flushContents',
		'flushProcess',
		'contentReceived',
		'timeToWait',
		'baseDirectory',
		'versionLog'
	],
	#category : #'NewTools-Playground-Model'
}

{ #category : #accessing }
StPlaygroundPage class >> defaultTimeToWait [

	^ 10 seconds
]

{ #category : #'instance creation' }
StPlaygroundPage class >> fromReference: aFileReference [

	^ self new fromReference: aFileReference
]

{ #category : #accessing }
StPlaygroundPage class >> pageExtension [

	^ 'ph'
]

{ #category : #'inspector compatibility' }
StPlaygroundPage >> asInspectorModel [
	"Since the playground can be the starting point of an inspection (using <meta+g>), the 
	 playground page (which is the model of a playground) needs to behave as a valid starting point. 
	 This method declares the page as a valid inspector model."

	^ self
]

{ #category : #accessing }
StPlaygroundPage >> baseDirectory [
	
	^ baseDirectory ifNil:[ StPlayground cacheDirectory ]
]

{ #category : #accessing }
StPlaygroundPage >> baseDirectory: aDirectory [
	
	baseDirectory := aDirectory
]

{ #category : #private }
StPlaygroundPage >> basicContents: aString [ 
	
	flushContents := aString
]

{ #category : #accessing }
StPlaygroundPage >> contents [

	^ self fileReference 
		ifExists: [ :ref | ref contents ]
		ifAbsent: [ '' ]
]

{ #category : #accessing }
StPlaygroundPage >> contents: aString [

	aString asString trimmed ifEmpty: [ ^ self ].
	mutex critical: [
		self basicContents: aString.
		contentReceived := true.
		self spawnFlushProcess ]
]

{ #category : #accessing }
StPlaygroundPage >> creationTime [

	^ creationTime
]

{ #category : #private }
StPlaygroundPage >> creationTimeForFileName [

	^ (self creationTime asString 
		copyReplaceAll: ':' with: '-') 
		copyReplaceAll: '.' with: '-'
]

{ #category : #'inspector compatibility' }
StPlaygroundPage >> defaultObjectInspectorClass [
	"Since the playground can be the starting point of an inspection (using <meta+g>), the 
	 playground page (which is the model of a playground) needs to behave as a valid starting point. 
	 This method declares answer the presenter to use in the inspection miller list."

	^ StPlaygroundPagePresenter
]

{ #category : #accessing }
StPlaygroundPage >> ensureContentsFlushed [

	flushContents isEmptyOrNil ifTrue: [ ^ self ].
	self flush
]

{ #category : #accessing }
StPlaygroundPage >> fileName [

	^ fileName ifNil: [ fileName := self creationTimeForFileName ]
]

{ #category : #accessing }
StPlaygroundPage >> fileReference [

	^ (self baseDirectory / self fileName) withExtension: self class pageExtension
]

{ #category : #private }
StPlaygroundPage >> flush [

	mutex critical: [ 
		flushContents ifNil: [ ^ self ].
		self fileReference parent ensureCreateDirectory.
		self fileReference 
			ensureDelete;
			writeStreamDo: [ :stream |
				stream << flushContents ].
		flushContents := nil.
		self storeVersion ]
]

{ #category : #initialization }
StPlaygroundPage >> fromReference: aFileReference [

	aFileReference parent = self baseDirectory 
		ifFalse: [ self baseDirectory: aFileReference parent ].
	fileName := aFileReference basenameWithoutExtension.
	creationTime := aFileReference creationTime
]

{ #category : #initialization }
StPlaygroundPage >> initialize [

	super initialize.
	contentReceived := false.
	creationTime := DateAndTime now.
	mutex := Mutex new
]

{ #category : #private }
StPlaygroundPage >> spawnFlushProcess [

	(flushProcess notNil 
		and: [ flushProcess isTerminated not ])
		ifTrue: [ ^ self ].
		
	flushProcess := [
 		[ contentReceived ] whileTrue: [
			contentReceived := false.
			self timeToWait wait ].
		self flush.
		flushProcess := nil.
		"in case I need to restart"
		contentReceived ifTrue: [ self spawnFlushProcess ].
	] fork
]

{ #category : #private }
StPlaygroundPage >> storeVersion [
	| entry |

	"If last version is equal to the one that I want to store, skip it"
	self versions ifNotEmpty: [ :versions | 
		versions last content = self contents 
			ifTrue: [ ^ self ] ].
	"store new version"
	entry := OmEntry content: self contents.
	entry tags at: #timestamp put: DateAndTime now.
	self versionLog newEntry: entry
]

{ #category : #accessing }
StPlaygroundPage >> timeToWait [

	^ timeToWait ifNil: [ self class defaultTimeToWait ]
]

{ #category : #accessing }
StPlaygroundPage >> timeToWait: aDuration [

	timeToWait := aDuration
]

{ #category : #'accessing - versions' }
StPlaygroundPage >> versionLog [
	
	^ versionLog ifNil: [ 
		versionLog := OmFileStore fromFile: (self fileReference withExtension: 'ombu') ]
]

{ #category : #'accessing - versions' }
StPlaygroundPage >> versions [
	
	^ Array streamContents: [ :stream | 
		self versionLog entriesDo: [ :anEntry | 
			stream nextPut: anEntry ] ]
]
