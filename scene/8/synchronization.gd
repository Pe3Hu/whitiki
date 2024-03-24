extends MarginContainer


#region vars
@onready var min = $HBox/Rolls/Min
@onready var max = $HBox/Rolls/Max
@onready var action = $HBox/Action

var skill = null
var type = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	skill = input_.skill
	type = input_.type
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_rolls()
	init_action()


func init_rolls() -> void:
	var descriptions = Global.dict.skill.role[skill.role][skill.type]
	var index = Global.arr.synchronization.find(type)
	var rolls = descriptions[index].roll
	
	for extreme in Global.arr.extreme:
		var token = get(extreme)
		var input = {}
		input.proprietor = self
		input.type = "extreme"
		input.subtype = extreme
		input.value = rolls[extreme]
		token.set_attributes(input)
		token.custom_minimum_size = Global.vec.size.extreme
	


func init_action() -> void:
	var descriptions = Global.dict.skill.role[skill.role][skill.type]
	var index = Global.arr.synchronization.find(type)
	var description = descriptions[index]
	
	var input = {}
	input.proprietor = self
	input.type = "action"
	input.subtype = skill.type
	input.value = description.value
	input.count = description.count
	input.probability = description.probability * 100
	action.set_attributes(input)
	action.custom_minimum_size = Global.vec.size.action
#endregion
