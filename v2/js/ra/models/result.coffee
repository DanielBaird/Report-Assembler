
window.RA ||= {}
RA.Models ||= {}

RA.Models.Result = Backbone.Model.extend {
	# -----------------------------------------------------
	defaults:
		data: null
		doc: null
	# -----------------------------------------------------
	initialize: () ->

		me = this

		@.on('change:data',
			() ->
				@.get('data').on('change',
					() ->
						console.warn "result data changed"
						me.trigger 'change'
				, me)
		, me)

		@.on('change:doc',
			() ->
				@.get('doc').on('change',
					() ->
						console.warn "result doc changed"
						me.trigger 'change'
				, me)
		, me)
	# -----------------------------------------------------
}
