
window.RA ||= {}
RA.Models ||= {}

RA.Models.App = Backbone.Model.extend {
	# -----------------------------------------------------
	# -----------------------------------------------------
	initialize: () ->
		@datasets = new RA.Collections.Datasets()
		@documents = new RA.Collections.Documents()
		@result = new RA.Models.Result()
	# -----------------------------------------------------
	fetch: () ->
		@datasets.fetch {
			success: () ->
				console.log "got datasets"

			error: () ->
				alert "couldn't load datasets!"
		}

		@documents.fetch {
			success: () ->
				console.log "got documents"

			error: () ->
				alert "couldn't load documents!"
		}
	# -----------------------------------------------------
}
