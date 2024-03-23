extends MarginContainer


#region vars
@onready var designation = $HBox/Designation
@onready var first = $HBox/Stages/First
@onready var second = $HBox/Stages/Second
@onready var third = $HBox/Stages/Third

var career = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	career = input_.career
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	init_icons(input_)
	init_stages()
	update_designation_value()


func init_icons(input_: Dictionary) -> void:
	var input = {}
	input.type = "profession"
	input.subtype = input_.profession
	input.value = 0
	designation.set_attributes(input)
	designation.custom_minimum_size = Global.vec.size.stage


func init_stages() -> void:
	for subtype in Global.arr.stage:
		var input = {}
		input.proprietor = self
		input.type = "stage"
		input.subtype = subtype
		input.value = 0
		
		var stage = get(subtype)
		stage.set_attributes(input)
		stage.custom_minimum_size = Global.vec.size.stage


func update_designation_value() -> void:
	designation.set_value(0)
	
	for subtype in Global.arr.stage:
		var stage = get(subtype)
		var _value = stage.get_value()
		designation.change_value(_value)
#endregion
