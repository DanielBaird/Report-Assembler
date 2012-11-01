
window.RA ||= {}
RA.Models ||= {}

RA.Models.Document = Parse.Object.extend {
	# -----------------------------------------------------
	className: "Document"
	# -----------------------------------------------------
	defaults:
		name: "a document"
		parts: [
			{ condition: 'always', content: 'A and B are always interesting.' }
			{ condition: 'a == b', content: 'In this case, A and B are both $$a.' }
		]
	# -----------------------------------------------------
}
