
window.RA ||= {}
RA.Views ||= {}

# view into a collection of datasets
RA.Views.DatasetList = Backbone.View.extend {

	tagName: 'div'
	className: 'datasets'

	initialize: () ->
		console.log "init-ing a RA.Views.DatasetList"
#		@model.bind 'reset', this.render, this

	render: () ->
		html = "<h2>Datasets</h2>"
		@$el.html(html)
		_.each( @model.models, (set) ->
			@$el.append( new RA.Views.SingleDataset({model: set}).render().el )
		this)

		console.log 'rendered DatasetList'
		return this # return this, coz we might use that later
}

# -------------------------------------------------------------------

# view of vars etc in a single dataset
RA.Views.SingleDataset = Backbone.View.extend {

	tagName: 'div'
	className: 'singleDataset'

	initialize: () ->
		console.log "init-ing a RA.Views.SingleDataset"
#		@model.bind 'reset', this.render, this

	render: () ->
		html = ''
		name = @model.get 'name'
		html += "<h3 class='name'>#{name}</h3>"
		_.each @model.get('vars'), (varvalue, varname) ->
			html += "#{varname}: #{varvalue}<br>"
		@$el.append(html)
		@
}

