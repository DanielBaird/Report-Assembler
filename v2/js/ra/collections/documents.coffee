
window.RA ||= {}
RA.Collections ||= {}

RA.Collections.Documents = Parse.Collection.extend {
# Backbone.Collection.extend {
	model: RA.Models.Document
}

