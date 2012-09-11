window.RA ||= {}
RA.Views ||= {}

# view into a collection of datasets
RA.Views.App = Backbone.View.extend {

	tagName: 'div'
	className: 'app'
	docView: null
	dataView: null


	initialize: () ->
		@docView = new RA.Views.DatasetList { model: @model.datasets }
		@dataView = new RA.Views.DocumentList { model: @model.documents }

#		me = this

		@model.datasets.on 'change', @render(), this

#		@model.documents.on 'change', () ->
#			me.render()

		console.log "init-ing a RA.Views.App"


	refresh: () ->
		@model.fetch()


	render: () ->
		html = """
		<div class="header">
			<h1>Report Assembler</h1>
		</div>

		<div class="matcher clearfix">
		</div>

		<div class="result">
		</div>

		<div class="footer">footer</div>
		"""

		@$el.html(html)
		@$el.find('.matcher').append @docView.render().el
		@$el.find('.matcher').append @dataView.render().el

		this # return this, coz we might use that later
}

