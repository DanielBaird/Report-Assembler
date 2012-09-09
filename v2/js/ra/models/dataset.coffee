
window.RA ||= {}
RA.Models ||= {}

RA.Models.Dataset = Backbone.Model.extend({

	initialize: () ->
		alert "data set awayyy!"

	defaults:
		name: "a data set"
		updated: 2010
		vars: {
			a: 12
			b: 14
		}

})
