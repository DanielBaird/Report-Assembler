
window.RA ||= {}
RA.Views ||= {}

# view into a collection of datasets
RA.Views.DatasetList = Backbone.View.extend {

	tagName: 'div'
	className: 'datasets'

	events:
		"click #newdataset": "addNew"

	initialize: () ->
		console.log "init-ing a RA.Views.DatasetList"
		@model.on 'add', @render, this
		@model.on 'remove', @render, this

	render: () ->
		html = """
		<h2>Datasets</h2>
		<button id="newdataset">new</button>
		"""
		@$el.html(html)
		_.each( @model.models, (set) ->
			@$el.append( new RA.Views.SingleDataset({model: set}).render().el )
		this)

		console.log 'rendered DatasetList'
		return this # return this, coz we might use that later

	addNew: () ->
		@model.create {
			editing: true
		}
}

# -------------------------------------------------------------------

# view of vars etc in a single dataset
RA.Views.SingleDataset = Backbone.View.extend {

	tagName: 'div'
	className: 'singleDataset'

	events:
		"click .edit": "startEdit"
		"click .save": "saveEdit"
		"click .cancel": "cancelEdit"

		"click .maybedelete": "showDelete"
		"click .dontdelete": "hideDelete"
		"click .delete": "delete"

	initialize: () ->
		console.log "init-ing a RA.Views.SingleDataset"
		@model.on 'change', @render, this

	render: () ->

		name = @model.get 'name'

		html = """
		<button class="edit">edit</button>
		<button class="maybedelete">delete</button>
		<button class="dontdelete">not really</button>
		<button class="delete">really delete?</button>
		<h3 class="name">#{name}</h3>
		"""

		if @model.get 'editing'
			html = """
			<button class="save">save</button>
			<button class="cancel">cancel</button>
			<input type="text" value="#{name}" />
			"""

		@$el.html(html)

		varslist = $('<pre></pre>')
		varslist = $("<textarea>\n</textarea>") if @model.get 'editing'

		@$el.append(varslist)

		_.each @model.get('vars'), (varvalue, varname) ->
			varslist.append "#{varname}: #{varvalue}\n"

		@$el.toggleClass 'editing', @model.get('editing')

		this # return this


	startEdit: () ->
		@$el.addClass 'editing'
		@model.set 'editing', true


	cancelEdit: () ->
		@model.set 'editing', false


	saveEdit: () ->
		newvars = {}

		lines = @.$('textarea').val().split("\n")
		_.each lines, (line) ->
			bits = line.split /\s*:\s*/
			if bits.length == 2
				newvars[bits[0]] = bits[1]

		@model.set {
			vars: newvars
			name: @.$('input').val()
			editing: false
		}

		@model.save()


	showDelete: () ->
		@.$('.maybedelete').hide()
		@.$('.dontdelete').show()
		@.$('.delete').show()



	hideDelete: () ->
		@.$('.dontdelete').hide()
		@.$('.delete').hide()
		@.$('.maybedelete').show()


	delete: () ->
		@model.destroy()

}

