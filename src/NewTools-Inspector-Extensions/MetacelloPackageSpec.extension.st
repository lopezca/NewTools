Extension { #name : #MetacelloPackageSpec }

{ #category : #'*NewTools-Inspector-Extensions' }
MetacelloPackageSpec >> inspectionRequires [
	<inspectorPresentationOrder: 10 title: 'Require'>
	| specs |

	specs := self project version spec packageSpecsInLoadOrder.
	^ SpListPresenter new
		items: (specs select: [ :each | self requires includes: each name ]);
		display: [ :aSpec | aSpec name ];
		yourself
]

{ #category : #'*NewTools-Inspector-Extensions' }
MetacelloPackageSpec >> inspectionRequiresContext: aContext [
		
	aContext active: self requires isNotEmpty
]

{ #category : #'*NewTools-Inspector-Extensions' }
MetacelloPackageSpec >> type [

	^ 'package'
]
