
window.RA ||= {}
RA.Views ||= {}

# view into a collection of Documents
RA.Views.DocumentList = Backbone.View.extend {

	tagName: 'div'
	className: 'documents'

	initialize: () ->
		console.log "init-ing a RA.Views.DocumentList"
		@model.on 'all', @render, this

	render: () ->
		html = "<h2>Documents</h2>"
		@$el.html(html)
		_.each( @model.models, (set) ->
			@$el.append( new RA.Views.SingleDocument({model: set}).render().el )
		this)

		console.log 'rendered DocumentList'
		return this # return this, coz we might use that later
}

# -------------------------------------------------------------------

# view of vars etc in a single Document
RA.Views.SingleDocument = Backbone.View.extend {

	tagName: 'div'
	className: 'singleDocument'

	initialize: () ->
		console.log "init-ing a RA.Views.SingleDocument"
		@model.on 'change', @render, this

	render: () ->
		html = ''
		name = @model.get 'name'
		html += "<h3 class='name'>#{name}</h3>"
		_.each @model.get('parts'), (part) ->
			html += "#{part['condition']}: #{part['content']}<br>"
		@$el.append(html)
		@
}

