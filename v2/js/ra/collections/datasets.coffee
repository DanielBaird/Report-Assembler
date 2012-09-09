
window.RA ||= {}
RA.Collections ||= {}

RA.Collections.Datasets = Backbone.Collections.extend {
	model: RA.Models.Dataset
}