
window.RA ||= {}
RA.Models ||= {}

RA.Models.Dataset = Parse.Object.extend {
	# -----------------------------------------------------
	className: "Dataset"
	# -----------------------------------------------------
	initialise: () ->
		#
	# -----------------------------------------------------
	defaults:
		name: "unnamed dataset"
		vars: { zero: 0 }
		editing: false
	# -----------------------------------------------------
}
