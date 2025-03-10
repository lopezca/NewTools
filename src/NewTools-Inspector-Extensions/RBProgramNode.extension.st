Extension { #name : #RBProgramNode }

{ #category : #'*NewTools-Inspector-Extensions' }
RBProgramNode >> inspectionASTDump [
	<inspectorPresentationOrder: 50 title: 'AST Dump'>

	^ SpCodePresenter new 
		text: (RBParser parseExpression: self dump) formattedCode; 
		beForScripting; "this is an expression"
		yourself
]

{ #category : #'*NewTools-Inspector-Extensions' }
RBProgramNode >> inspectionSourceCode [
	<inspectorPresentationOrder: 30 title: 'Source code'>

	^ SpCodePresenter new 
		beForMethod: self methodNode;
		text: (self source ifNil: [ self formattedCode ]);
		addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
			interval: (self sourceInterval first to: self sourceInterval last + 1);
			yourself);
		yourself
]

{ #category : #'*NewTools-Inspector-Extensions' }
RBProgramNode >> inspectionTree [
	<inspectorPresentationOrder: 35 title: 'Tree'>

	^ SpTreePresenter new 
		roots: { self };
		children: [ :aNode | aNode children ];
		display: [ :each | 
			String
				streamContents: [ :stream | 
					stream
						nextPutAll: each class name;
						nextPut: $(;
						nextPutAll: ((each formattedCode truncateTo: 50) copyReplaceAll: String cr with: String space);
						nextPut: $)
			 ] ];
		yourself
]
