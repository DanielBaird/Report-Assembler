
window.RA ||= {}
RA.Models ||= {}

RA.Models.App = Backbone.Model.extend {

#	defaults:
#		datasets: new RA.Collections.Datasets()
#		documents: new RA.Collections.Documents()


	initialize: () ->
		@datasets = new RA.Collections.Datasets()
		@documents = new RA.Collections.Documents()

#		@datasets.on 'change', () ->
#			@trigger 'change'

#		@documents.on 'change', () ->
#			@trigger 'change'


	fetch: () ->

		ds = @datasets

		@datasets.fetch {
			success: (collection) ->
				console.log "got datasets"
#				ds.reset collection
#				collection.trigger 'change'

			error: () ->
				console.warn "didn't get datasets"

		}

		@documents.fetch {
			success: (collection) ->
				console.log "got documents"
				collection.trigger 'change'

			error: () ->
				console.warn "didn't get documents"

		}

}
