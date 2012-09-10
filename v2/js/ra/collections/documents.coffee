
window.RA ||= {}
RA.Collections ||= {}

RA.Collections.Documents = Backbone.Collection.extend {
	model: RA.Models.Document
}

