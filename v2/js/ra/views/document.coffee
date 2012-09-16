
window.RA ||= {}
RA.Views ||= {}
# =========================================================
# view into a collection of Documents
RA.Views.DocumentList = Backbone.View.extend {
	# -----------------------------------------------------
	tagName: 'div'
	className: 'documents'
	docViews: []
	# -----------------------------------------------------
	events:
		"click #newdocument": "addNew"
	# -----------------------------------------------------
	initialize: () ->
#		console.log "init-ing a RA.Views.DocumentList"
		@model.on 'all', @render, this
	# -----------------------------------------------------
	render: () ->
		html = """
		<button id="newdocument">new</button>
		<h2>Documents</h2>
		"""
		@$el.html(html)
		_.each( @model.models, (set) ->
			view = new RA.Views.SingleDocument({model: set})
			@docViews.push view
			view.on(
				'chosen'
				(chosenDoc) ->
					@trigger 'docSelected', chosenDoc.cid
				this
			)
			@$el.append( view.render().el )
		this)

		console.log 'rendered DocumentList'
		return this # return this, coz we might use that later
	# -----------------------------------------------------
	deselectAllExcept: (cid) ->
		_.each @docViews, (view) ->
			view.unchoose() if view.model.cid isnt cid
	# -----------------------------------------------------
	addNew: () ->
		@model.create {
			editing: true
		}
	# -----------------------------------------------------
}
# =========================================================
# view of vars etc in a single Document
RA.Views.SingleDocument = Backbone.View.extend {
	# -----------------------------------------------------
	tagName: 'div'
	className: 'singleDocument'
	# -----------------------------------------------------
	events:
		"click .choose": "choose"

		"click .edit": "startEdit"
		"click .save": "saveEdit"
		"click .cancel": "cancelEdit"

		"click .maybedelete": "showDelete"
		"click .dontdelete": "hideDelete"
		"click .delete": "delete"
	# -----------------------------------------------------
	initialize: () ->
		console.log "init-ing a RA.Views.SingleDocument"
		@model.on 'change', @render, this
	# -----------------------------------------------------
	render: () ->
		name = @model.get 'name'

		html = """
		<button class="choose">choose</button>
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

		partslist = $('<pre></pre>')
		partslist = $("<textarea>\n</textarea>") if @model.get 'editing'

		@$el.append(partslist)

		_.each @model.get('parts'), (part) ->
			partslist.append "[[#{part.condition}]] #{part.content}\n"

		@$el.toggleClass 'editing', @model.get('editing')

		this # return this
	# -----------------------------------------------------
	unchoose: () ->
		@$el.removeClass 'chosen'
	# -----------------------------------------------------
	choose: () ->
		@$el.addClass 'chosen'
		@.trigger 'chosen', @model
	# -----------------------------------------------------
	startEdit: () ->
		@$el.addClass 'editing'
		@model.set 'editing', true
	# -----------------------------------------------------
	cancelEdit: () ->
		@model.set 'editing', false
	# -----------------------------------------------------
	saveEdit: () ->
		newparts = []

		parts = @.$('textarea').val().split /[^\S\n]*\[\[\s*/
#		console.log ['parts', parts]
		_.each parts, (part) ->
			bits = part.split /\s*\]\][^\S\n]*/
			console.log ['bits', bits]
			if bits.length > 1
				newparts.push {
					condition: bits[0]
					content: bits.slice(1).join(" ]] ")
				}

		@model.save {
			parts: newparts
			name: @.$('input').val()
			editing: false
		}
	# -----------------------------------------------------
	showDelete: () ->
		@.$('.maybedelete').hide()
		@.$('.dontdelete').show()
		@.$('.delete').show()
	# -----------------------------------------------------
	hideDelete: () ->
		@.$('.dontdelete').hide()
		@.$('.delete').hide()
		@.$('.maybedelete').show()
	# -----------------------------------------------------
	delete: () ->
		@model.destroy()
	# -----------------------------------------------------
}
# =========================================================


