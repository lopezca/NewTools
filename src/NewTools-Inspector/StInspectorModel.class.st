"
An model to provide inspector data on an inspected object.
The inspector wraps all inspected objects with this to being able to display values. 
"
Class {
	#name : #StInspectorModel,
	#superclass : #Object,
	#instVars : [
		'inspectedObject'
	],
	#category : #'NewTools-Inspector-Model'
}

{ #category : #accessing }
StInspectorModel class >> maxTitleLength [

	^ 40
]

{ #category : #'instance creation' }
StInspectorModel class >> new [ 

	self error: 'Use #on:'
]

{ #category : #'instance creation' }
StInspectorModel class >> on: anObject [

	^ super new inspectedObject: anObject
]

{ #category : #accessing }
StInspectorModel >> allInspectorNodes [

	^ self inspectedObject allInspectorNodes
]

{ #category : #converting }
StInspectorModel >> asInspectorModel [

	^ self
]

{ #category : #accessing }
StInspectorModel >> behavior [ 
	
	^ self inspectedObject class
]

{ #category : #accessing }
StInspectorModel >> descriptionString [

	^ self descriptionStringFor: self inspectedObject
]

{ #category : #accessing }
StInspectorModel >> descriptionStringFor: object [
	| header printString |
	
	header := (object class name first isVowel
		ifTrue: [ 'an ' ]
		ifFalse: [ 'a ' ]) , 
		object class name.
	
	printString := self smallDescriptionStringFor: object.
	^ ((printString beginsWith: header)
		ifTrue: [ printString ]
		ifFalse: [ 
			String streamContents: [ :out | 
				out << header; << ' ('; << printString; << ')' ] ])
]

{ #category : #accessing }
StInspectorModel >> inspectedObject [

	^ inspectedObject
]

{ #category : #accessing }
StInspectorModel >> inspectedObject: anObject [

	inspectedObject := anObject
]

{ #category : #accessing }
StInspectorModel >> labelString [
	
	^ self descriptionString truncateWithElipsisTo: 30
]

{ #category : #accessing }
StInspectorModel >> objectInspectionContexts [

	^ self inspectedObject inspectionContexts
]

{ #category : #printing }
StInspectorModel >> printOn: stream [

	super printOn: stream.
	stream << '('.
	stream print: self inspectedObject.
	stream << ')'
]

{ #category : #accessing }
StInspectorModel >> smallDescriptionString [
	
	^ (StObjectPrinter asTruncatedTextFrom: self inspectedObject) asString
]

{ #category : #accessing }
StInspectorModel >> smallDescriptionStringFor: anObject [
	
	^ (StObjectPrinter asTruncatedTextFrom: anObject) asString
]

{ #category : #accessing }
StInspectorModel >> windowTitle [

	^ 'Inspector on {1}' format:
		  { ([ self inspectedObject displayString truncateWithElipsisTo: self class maxTitleLength ]
			   on: Exception
			   do: [ :e | e printString ]) }
]
