Class {
	#name : #StSpotterTest,
	#superclass : #StSpotterBaseTest,
	#instVars : [
		'spotter'
	],
	#category : #'NewTools-Spotter-Tests'
}

{ #category : #running }
StSpotterTest >> setUp [
	
	super setUp.
	spotter := StSpotter new
]

{ #category : #tests }
StSpotterTest >> testOpenSpotterRefreshesPreviewOnce [

	| count |
	"I need to skip it because this CI seems to not run it properly"
	self skipOnPharoCITestingEnvironment.

	count := 0.
	spotter previewContainer whenChildrenAddedDo: [ :ann | 
		count := count + 1 ].

	spotter open.
	spotter updateSearch: 'Obj'.
	self waitUntilEnded: spotter model.
	20 timesRepeat: [ self waitUntilUIRedrawed ].
	spotter window close.

	self assert: count equals: 1
]

{ #category : #tests }
StSpotterTest >> testSearchingString [

	spotter searchText text: 'Test'.
	self assert: spotter searchingString equals: 'Test'.
	
	spotter searchText text: '#Classes Test'.
	self assert: spotter searchingString equals: 'Test'.
	
	spotter searchText text: '#Classes #Implementors Test'.
	self assert: spotter searchingString equals: 'Test'.
	
	spotter searchText text: '#Classes Test #Implementors'.
	self assert: spotter searchingString equals: 'Test'.
	
	spotter searchText text: '#Classes Test a thing #Implementors'.
	self assert: spotter searchingString equals: 'Test a thing'.
]
