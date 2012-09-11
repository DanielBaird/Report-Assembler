
window.RA ||= {}
RA.Models ||= {}

RA.Models.Dataset = Parse.Object.extend {
	className: "Dataset"
#Backbone.Model.extend {

#	initialize: () ->

	defaults:
		name: "unnamed dataset"
		vars: { zero: 0 }
		editing: false

}
