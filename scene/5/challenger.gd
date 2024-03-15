extends MarginContainer


#region vars
@onready var marker = $HBox/Marker
@onready var accuracy = $HBox/Accuracy

var challenge = null
var god = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	challenge = input_.challenge
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_tokens()


func init_tokens() -> void:
	var input = {}
	input.proprietor = self
	input.type = "moon"
	input.subtype = "lap"
	marker.set_attributes(input)
	marker.replicate(god.marker)
	
	input.type = "accuracy"
	input.subtype = "standard"
	accuracy.set_attributes(input)
