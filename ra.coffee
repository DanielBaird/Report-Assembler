
$ ->
	doc = {
		vars:
			a: 101
			b: 4
		sections:
			intro:
				title: 'Introduction'
				vars:
					b: 12
				texts: [
					{
						content: 'A and B are always interesting.'
					}
					{
						condition: 'never'
						content: "If you are reading this, contact Jeremy for a free drink."
					}
					{
						condition: 'a == b'
						content: 'In this case, A and B are both $$a.'
					}
					{
						condition: 'a != b'
						content: 'In this case, A is $$a.'
					}
					{
						condition: 'a > b'
						content: 'That is larger than B, which is $$b.'
					}
					{
						condition: 'a < b'
						content: 'That is smaller than B, which is $$b.'
					}
					{
						condition: 'a < 100'
						content: "At least A is below 100.  Lucky, coz if A gets past 100 everyone catches on fire."
					}
					{
						condition: 'a > 99'
						content: "Get out of there! When A gets past 100, everyone catches on fire!"
					}
				]
	}

	RA.produce(doc)


RA = window.RA = {}

RA.resolve_term = (term, vars) ->
	if isNaN term
		vars[term]
	else
		parseInt term

RA.holds = (condition, vars) ->
	conditions = {

		"never": () ->
			false

		"always": () ->
			true

		"(\\S+)\\s*(<|>|==?|!==?|<>)\\s*(\\S+)": (matches, vars) ->

			left = RA.resolve_term matches[1], vars
			right = RA.resolve_term matches[3], vars

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

	if condition == undefined
		return true

	for pattern, evaluator of conditions
		regex = new RegExp pattern
		match_result = regex.exec condition
		if match_result != null
			return evaluator(match_result, vars)


RA.fillout = (content, vars) ->
	for varname, value of vars
		content = content.replace("\$\$" + varname, value)
	content


RA.do_section = (name, section, globals) ->
	is_blank = true

	# merge in globals with section vars
	merged_vars = $.extend {}, globals, section.vars
	for text in section.texts
		if RA.holds(text.condition, merged_vars)
#			if is_blank and section.title?
#				$('body').append "<h2>#{section.title}</h2>"

			is_blank = false
			$('body').append RA.fillout(text.content, merged_vars)
			$('body').append " "


RA.produce = (doc) ->
	for name, section of doc.sections
		RA.do_section name, section, doc.vars


