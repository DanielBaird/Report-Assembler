
window.RA ||= {}
RA.Models ||= {}

RA.Models.Document = Backbone.Model.extend {

#	initialize: () ->

	defaults:
		name: "a document"
		parts: [
			{ condition: 'always', content: 'A and B are always interesting.' }
			{ condition: 'a == b', content: 'In this case, A and B are both $$a.' }
		]
}
