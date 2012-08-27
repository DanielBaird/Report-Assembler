
RA = window.RA = {}

RA.holds = (condition, vars) ->
	if condition == 'always'
		return true
	gtmatch = /$$\S+ > $$\S+/.exec conditon
	console.log gtmatch

RA.fillout = (content, vars) ->
	return content

RA.do_section = (name, section) ->
	alert "doing #{name}"
	for text in section.texts
		if RA.holds(text.condition, text.vars)
			$('body').append(RA.fillout(text.content, text.vars))

RA.start = ->
	doc = sections:
	  	intro:
	    	vars:
	        	a: 10
	        	b: 12
	    	texts: [
	    		{
	    			condition: 'always'
	    			content: 'A is $$a.'
	    		}
	        	{
	    	  		condition: '$$a > $$b'
	      			content: 'That is larger than B, which is $$b.'
	        	}
	      	]

	console.log(doc)

	for name, section of doc.sections
		RA.do_section name, section 

	false


$ ->
	RA.start()



