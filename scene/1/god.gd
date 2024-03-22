extends MarginContainer


#region vars
@onready var marker = $HBox/VBox/HBox/Marker
@onready var core = $HBox/VBox/HBox/Core
@onready var summary = $HBox/VBox/Summary

var pantheon = null
var rank = null
var planet = null
var opponents = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	pantheon = input_.pantheon
	rank = input_.rank
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.god = self
	core.set_attributes(input)
	summary.set_attributes(input)
	init_marker()


func init_marker() -> void:
	var input = {}
	input.proprietor = self
	input.type = "marker"
	
	if !Global.dict.marker.unlocked.is_empty():
		input.subtype = Global.dict.marker.unlocked.pick_random()
	else:
		input.subtype = Global.dict.marker.locked.pick_random()
	
	Global.dict.marker.unlocked.erase(input.subtype)
	Global.dict.marker.locked.append(input.subtype)
	marker.set_attributes(input)
#endregion


func pick_opponent() -> MarginContainer:
	var opponent = opponents.pick_random()
	return opponent
