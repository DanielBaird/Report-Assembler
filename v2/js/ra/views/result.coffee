window.RA ||= {}
RA.Views ||= {}

# view into a collection of datasets
RA.Views.Result = Backbone.View.extend {
	# -----------------------------------------------------
	tagName: 'div'
	className: 'result'
	# -----------------------------------------------------
	initialize: () ->
		console.log "init-ing a RA.Views.Result"
		@model.on 'all', @render, this
		@mdConverter = new Showdown.converter()
	# -----------------------------------------------------
	render: () ->
		data = @model.get('data')
		doc = @model.get('doc')

		if doc? and data?
			mdResult = @resolveResult()
			htmlResult = @mdConverter.makeHtml mdResult
			console.log [mdResult, htmlResult]
			html = """
			<div class="markdownresult">
				<h3>Resulting Report - Markdown</h3>
				<pre>
				#{mdResult}
				</pre>
				</div>
			<div class="htmlresult">
				<h3>Resulting Report - HTML</h3>
				<div class="html">
					#{htmlResult}
				</div>
			</div>
			"""

		else

			if doc?
				html = """
					<span class="subtle">choose a dataset.</span>
				"""
			else if data?
				html = """
					<span class="subtle">choose a document.</span>
				"""
			else
				html = """
					<span class="subtle">choose a dataset and a document.</span>
				"""

		@$el.html(html)

		this # return this, coz we might use that later
	# -----------------------------------------------------
	resolveResult: () ->
		result = []
		_.each(
			@model.get('doc').get('parts')
			(part) ->
				if @conditionHolds part.condition
#					console.log ["true:", part.condition, part.content]
					result.push @fillOut(part.content)
#				else
#					console.log ["NOT true:", part.condition, part.content]
			this
		)
		result.join ""

	# -----------------------------------------------------
	fillOut: (content) ->
		filledOut = content
		for varname, value of @model.get('data').get('vars')
			filledOut = filledOut.replace("\$\$" + varname, value)
		
		filledOut
	# -----------------------------------------------------
	resolveTerm: (term) ->
		if isNaN term
			@model.get('data').get('vars')[term]
		else
			parseInt term
	# -----------------------------------------------------
	conditionHolds: (condition) ->
		me = this
		conditions = {

			"never": () ->
				false

			"always": () ->
				true

			"(\\S+)\\s*(<|>|==?|!==?|<>)\\s*(\\S+)": (matches) ->
				left = me.resolveTerm matches[1]
				right = me.resolveTerm matches[3]

				switch matches[2]
					when '<'
						left < right
					when '>'
						left > right
					when '=','=='
						left == right
					when '!=','!==','<>'
						left != right
		}

		unless condition?
			return true

		for pattern, evaluator of conditions
			regex = new RegExp pattern
			match_result = regex.exec condition
			if match_result?
				return evaluator match_result


}

