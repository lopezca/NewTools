"
I override methods related to opening a file dialog to use my own file dialog instead of the system's one.

To use me by default, see class-side.
"
Class {
	#name : #StFBMorphicUIManager,
	#superclass : #MorphicUIManager,
	#category : #'NewTools-FileBrowser-UI'
}

{ #category : #public }
StFBMorphicUIManager class >> beDefault [
	<script>
	self new beDefault
]

{ #category : #testing }
StFBMorphicUIManager class >> isActiveManager [
	"This is just a temporary UI manager and it should not be enabled by the system by default."

	^ false
]

{ #category : #testing }
StFBMorphicUIManager class >> isValidForCurrentSystemConfiguration [

	"Has to return false, otherwise UIManager will select this one as default automatically when the image is opened"

	^ false
]

{ #category : #'ui requests' }
StFBMorphicUIManager >> chooseDirectory: label from: dir [
	self flag: #ToDoWhenIntegration.
	self flag: 'use chooseDirectory:path: instead of this'.
	^ StFBOpenDirectoryDialog new
		defaultFolder: dir;
		title: (label ifNil: [ 'Choose Directory' translated ]);
		open
]

{ #category : #'ui requests' }
StFBMorphicUIManager >> chooseDirectory: label path: path [

	^ StFBOpenDirectoryDialog new
		  defaultFolder:
			  (path ifNil: [ 
					   StFBFileNavigationSystemPresenter defaultDirectory ]);
		  title: (label ifNil: [ 'Choose Directory' translated ]);
		  openModal;
		  selectedEntry
]

{ #category : #'ui requests' }
StFBMorphicUIManager >> chooseFileMatching: patterns label: label [
	self deprecated: 'now you have to give a filter see NewTools-FileBrowser-Filtering'.
	^ StFBOpenFileDialog new
		title: (label ifNil: [ 'Choose File' translated ]);
		"fileFilters: pattern  ;"
		open
]

{ #category : #'ui requests' }
StFBMorphicUIManager >> chooseFileName: title extensions: exts path: path preview: preview [
	self
		deprecated: 'now you have to give a filter see FileDialog-filterStrategie'.
	^ (StFBOpenFileDialog new
		title: (title ifNil: [ 'Choose File' translated ]);
		"fileFilters: (exts ifNil: [ #() ] ifNotNil: [ :e | e collect: [ :each | '*.' , each ] ]);"
			defaultFolder: path;
			previewer: preview;
		open) ifNotNil: #basename
]

{ #category : #'ui requests' }
StFBMorphicUIManager >> chooseFullFileName: title extensions: exts path: path preview: preview [
	self
		deprecated: 'now you have to give a filter see FileDialog-filterStrategie'.
	^ (StFBOpenFileDialog new
		title: (title ifNil: [ 'Choose File' translated ]);
		"fileFilters: (exts ifNil: [ #() ] ifNotNil: [ :e | e collect: [ :each | '*.' , each ] ]);"
			defaultFolder: path;
			previewer: preview;
		open) ifNotNil: #fullName
]

{ #category : #'ui requests' }
StFBMorphicUIManager >> chooseFullFileNameMatching: patterns label: title [
	self
		deprecated: 'now you have to give a filter see FileDialog-filterStrategie'.
	^ StFBOpenFileDialog new
		title: (title ifNil: [ 'Choose File' translated ]);
		"fileFilters: (patterns ifNil: [ #() ] ifNotNil: [ :e | e collect: [ :each | '*.' , each ] ]);
		"
			open
]

{ #category : #'ui requests' }
StFBMorphicUIManager >> fileOpen: title extensions: exts path: path preview: preview [
	self
		deprecated: 'now you have to give a filter see FileDialog-filterStrategie'.
	^ (StFBOpenFileDialog new
		title: (title ifNil: [ 'Choose File' translated ]);
		"fileFilters: (exts ifNil: [ #() ] ifNotNil: [ :e | e collect: [ :each | '*.' , each ] ]);
		"defaultFolder: path;
		previewer: preview;
		openModal) ifNotNil: #readStream
]

{ #category : #'ui requests' }
StFBMorphicUIManager >> fileSave: title extensions: exts path: path [
	self
		deprecated: 'now you have to give a filter see FileDialog-filterStrategie'.
	^ StFBSaveFileDialog new
		title: (title ifNil: [ 'Choose File' translated ]);
		"fileFilters: (exts ifNil: [ #() ] ifNotNil: [ :e | e collect: [ :each | '*.' , each ] ]);
		"
			defaultFolder: path;
		open
]
