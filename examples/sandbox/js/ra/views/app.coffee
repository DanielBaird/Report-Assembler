window.RA ||= {}
RA.Views ||= {}

# view into a collection of datasets
RA.Views.App = Backbone.View.extend {
	# -----------------------------------------------------
	tagName: 'div'
	className: 'app'
	docView: null
	dataView: null
	resView: null
	# -----------------------------------------------------
	initialize: () ->
		@dataView = new RA.Views.DatasetList { model: @model.datasets }
		@docView = new RA.Views.DocumentList { model: @model.documents }
		@resView = new RA.Views.Result { model: @model.result }

		@dataView.on 'dataSelected', @selectData, this
		@docView.on 'docSelected', @selectDoc, this

		console.log "init-ing a RA.Views.App"
	# -----------------------------------------------------
	refresh: () ->
		@model.fetch()
	# -----------------------------------------------------
	selectData: (cid) ->
		console.log "switching to data #{cid}"
		@dataView.deselectAllExcept(cid)
		@resView.model.set { 'data': @dataView.model.getByCid(cid) }
	# -----------------------------------------------------
	selectDoc: (cid) ->
		console.log "switching to doc #{cid}"
		@docView.deselectAllExcept(cid)
		@resView.model.set { 'doc': @docView.model.getByCid(cid) }
	# -----------------------------------------------------
	render: () ->
		html = """
		<div class="header">
			<h1>Report Assembler</h1>
		</div>

		<div class="matcher clearfix">
		</div>

		<div class="footer">footer</div>
		"""

		@$el.html(html)
		@$el.find('.matcher').append @dataView.render().el
		@$el.find('.matcher').append @docView.render().el
		@$el.find('.matcher').after @resView.render().el

		this # return this, coz we might use that later
	# -----------------------------------------------------
}

