
window.RA ||= {}
RA.Controllers ||= {}

RA.DatasetController = Backbone.Controller.extend {
	routes:
		'': 'index'
		'new': 'newDataset'

	index: () ->
		datasets = new RA.Collections.Datasets()
		

		# fake up getting these two datasets from the server..
		datasets = {
			testSet1:
				a: 12
				b: 14

			datasetTestTwo:
				a: 102
				b: 54
				c: 22

		}
		# ..hey, we got datasts array from the server!
		new RA.DatasetList { datasets: datasets }
}
