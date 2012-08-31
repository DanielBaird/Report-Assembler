
RA = window.RA = {}

RA.resolve_term = (term, vars) ->
	vars[term]

RA.holds = (condition, vars) ->
	conditions = {

		"always": () ->
			true

		"(\\S+)\\s*(<|>|=|==|!=|!==|<>)\\s*(\\S+)": (matches, vars) ->

			left = RA.resolve_term matches[1], vars
			right = RA.resolve_term matches[3], vars

			console.log left

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


RA.do_section = (name, section) ->
	console.log "doing #{name}"
	for text in section.texts
		if RA.holds(text.condition, section.vars)
			$('body').append RA.fillout(text.content, section.vars)
			$('body').append " "


RA.start = ->
	doc = sections:
	  	intro:
	    	vars:
	        	a: 10
	        	b: 10
	    	texts: [
	    		{
	    			content: 'A and B are always interesting.'
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
	      	]

	for name, section of doc.sections
		RA.do_section name, section 


$ ->
	RA.start()



