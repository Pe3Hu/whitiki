extends "res://scene/0/token.gd"


var aspects = []


func init_basic_setting(input_: Dictionary) -> void:
	custom_minimum_size = Vector2(Global.vec.size.token)
	init_icons(input_)
	init_aspects()


func init_aspects() -> void:
	var stages = Global.dict.craft.title[proprietor.designation.subtype].stages
	aspects.append_array(stages[designation.subtype])
	update_value()


func update_value() -> void:
	#print(["___", proprietor.designation.subtype, designation.subtype])
	value.set_number(0)
	
	for _designation in aspects:
		var aspect = proprietor.career.summary.get_aspect_based_on_designation(_designation)
		var _value = aspect.get_value()
		value.change_number(_value)
		var data = Global.dict.aspect.title[_designation]
		#print([data, _value])
