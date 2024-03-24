extends "res://scene/0/token.gd"


var count = null
var probability = null


func init_icons(input_: Dictionary) -> void:
	count = $Count
	probability = $Probability
	
	var input = {}
	input.type = type
	input.subtype = subtype
	designation.set_attributes(input)
	
	var keys = ["value", "count", "probability"]
	
	for key in keys:
		var icon = get(key)
		input.type = "number"
		input.subtype = 0
		
		if input_.has(key):
			input.subtype = input_[key]
	
		icon.set_attributes(input)
		icon.custom_minimum_size = Vector2(Global.vec.size.number)
		
		if !input_.has(key):
			icon.visible = false
	
	probability.convert_to_percentage()
