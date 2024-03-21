extends MarginContainer


#region vars
@onready var bg = $BG
@onready var designation = $HBox/Designation
@onready var rank = $HBox/Rank

var pedigree = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	pedigree = input_.pedigree
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	var input = {}
	input.type = "talent"
	input.subtype = input_.designation
	designation.set_attributes(input)
	designation.custom_minimum_size = Vector2(Global.vec.size.talent)
	
	input.type = "alphabet"
	input.subtype = input_.rank
	rank.set_attributes(input)
	rank.custom_minimum_size = Vector2(Global.vec.size.talent)
