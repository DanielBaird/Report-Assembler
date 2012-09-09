
window.RA ||= {}
RA.Views ||= {}

RA.Views.DatasetFull = Backbone.View.extend {

	tagName: 'div'
	className: 'fulldataset'

	events: {
		'click .name': 'handleNameClick'
	}

	initialize: () ->
		_.bindAll @, 'changeName'
		@model.bind 'change:name', @changeName

	changeName: () ->
		alert 'name changed' 

	handleNameClick: () ->
		alert 'tickled on name'

	render: () ->
		html = ''
		name = @model.get 'name'
		html += "<h3 class='name'>#{name}</h3>"
		html += '<dl>'
		for varname, value of @model.get 'vars'
			html += "<dt class='var#{varname}'>#{varname}</dt><dd>#{value}</dd>"
		html += '</dl>'
		alert html
		@.$el.innerHTML(html)
		@
}