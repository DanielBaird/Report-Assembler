
window.RA ||= {}
RA.Models ||= {}

RA.Models.Dataset = Backbone.Model.extend {

#	initialize: () ->

	defaults:
		name: "a data set"
		vars: {
			a: 12
			b: 14
		}

}
